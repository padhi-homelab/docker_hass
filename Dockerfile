FROM homeassistant/home-assistant:2026.11.0

COPY run.sh /etc/services.d/home-assistant/run

# Add `iputils` package for `ping` entity to work correctly.
# See: https://community.home-assistant.io/t/device-tracker-ping-entity-not-appearing/328005/9

RUN apk add --update --no-cache iputils

EXPOSE 8123
VOLUME ["/config","/media"]

HEALTHCHECK --interval=15s --timeout=3s --start-period=5s \
        CMD [ "wget", "-qSO", "/dev/null", "http://127.0.0.1:8123" ]
