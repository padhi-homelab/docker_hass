#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

# Adapted from the s6 run script at:
# https://github.com/tribut/homeassistant-docker-venv

USER="homeassistant"
GROUP="$USER"
DOCKER_UID="${DOCKER_UID:-1000}"
DOCKER_GID="${DOCKER_GID:-1000}"

UMASK="${UMASK:-}"

# If s6-applyuidgid is missing, install s6-ipcserver
REQUIRED_PACKAGES=""
type -t s6-applyuidgid >/dev/null || REQUIRED_PACKAGES="s6-ipcserver"

PACKAGES="${PACKAGES:-}"

VENV_PATH="${VENV:-/var/tmp/homeassistant-venv}"
CONFIG_PATH=/config

#
# Create user
#

# Some HA commands seem to fail if we don't have an actual user.
# ie: shell_command would return error code 255
bashio::log.info "Creating user $USER with $DOCKER_UID:$DOCKER_GID"

deluser "$USER" >/dev/null 2>&1 || true
delgroup "$GROUP" >/dev/null 2>&1 || true

# Re-use existing group (can't delgroup a group that is in use)
group="$(getent group "$DOCKER_GID" | cut -d: -f1 || true)"
if [ -z "$group" ]; then
  addgroup -g "$DOCKER_GID" "$GROUP"
else
  bashio::log.notice "Re-using existing group with gid $DOCKER_GID: $group"
  GROUP="$group"
fi

# Replace existing user (ensures correct shell and primary group)
user="$(getent passwd "$DOCKER_UID" | cut -d: -f1 || true)"
if [ -n "$user" ]; then
  bashio::log.notice "Replacing existing user with uid $DOCKER_UID: $user"
  deluser "$user"
fi
adduser -G "$GROUP" -D -u "$DOCKER_UID" "$USER"

if [ -n "${EXTRA_GID:-}" ]; then
  bashio::log.info "Resolving supplementary GIDs: $EXTRA_GID"
  supplementary_groups=()

  for gid in $EXTRA_GID; do
    group="$(getent group "$gid" | cut -d: -f1 || true)"

    if [ -z "$group" ]; then
      group="$USER-$gid"
      addgroup -g "$gid" "$group"
    fi

    supplementary_groups+=( "$group" )
  done

  bashio::log.info "Appending supplementary groups: ${supplementary_groups[*]}"
  for group in "${supplementary_groups[@]}"; do
    addgroup "$USER" "$group"
  done
fi

#
# Install extra packages
#

for package in $REQUIRED_PACKAGES $PACKAGES; do
  if ! apk info --quiet --installed -- "$package"; then
    bashio::log.info "Installing package: $package"
    apk add --quiet --no-progress --no-cache -- "$package"
  fi
done

#
# Create virtual environment
#

bashio::log.info "Initializing venv in $VENV_PATH"
su "$USER" \
  -c "python3 -m venv --system-site-packages '$VENV_PATH'"

#
# Fix permissions
#

if [ -n "${UMASK}" ]; then
  bashio::log.info "Setting umask: $UMASK"
  umask "$UMASK"
fi

#
# Run homeassistant
#

bashio::log.info "Activating venv"
# shellcheck source=/dev/null
. "$VENV_PATH/bin/activate"
export UV_SYSTEM_PYTHON=false

bashio::log.info "Installing uv into venv"
uv --version && su "$USER" \
  -c "uv pip freeze --system|grep ^uv=|xargs uv pip install"

bashio::log.info "Setting new \$HOME"
HOME="$( getent passwd "$USER" | cut -d: -f6 )"
export HOME

# Everything below should be kept in sync with upstream's
#   https://github.com/home-assistant/core/blob/dev/rootfs/etc/services.d/home-assistant/run
cd "$CONFIG_PATH" || bashio::exit.nok "Can't find config folder: $CONFIG_PATH"

mkdir -p "$CONFIG_PATH/custom_components"
cp -r /hacs "$CONFIG_PATH/custom_components/"
chown -R $USER:$GROUP "$CONFIG_PATH"

# Enable Jemalloc for Home Assistant Core, unless disabled
if [[ -z "${DISABLE_JEMALLOC+x}" ]]; then
  export LD_PRELOAD="/usr/local/lib/libjemalloc.so.2"
  export MALLOC_CONF="background_thread:true,metadata_thp:auto,dirty_decay_ms:20000,muzzy_decay_ms:20000"
fi

bashio::log.info "Starting homeassistant"
exec \
  s6-setuidgid "$USER" \
  python3 -m homeassistant --config "$CONFIG_PATH"
