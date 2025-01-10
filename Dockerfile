FROM homeassistant/home-assistant:2025.1.2

ARG HACS_VERSION=2.0.2
ARG HACS_SHA_512=ca02c25166159bb660ab36dd4bdccecbca4a596fb154e51a101b1cdb643b6fc3600e727ae5d69ba3318eba73f6d4319b70a2bfcf0ebd3d2da2a0bb3ed80893a7

COPY run.sh /etc/services.d/home-assistant/run

ADD https://github.com/hacs/integration/releases/download/${HACS_VERSION}/hacs.zip \
    /tmp/hacs.zip

# Add `iputils` package for `ping` entity to work correctly.
# See: https://community.home-assistant.io/t/device-tracker-ping-entity-not-appearing/328005/9

RUN cd /tmp \
 && echo "${HACS_SHA_512}  hacs.zip" > hacs.zip.sha512 \
 && sha512sum -c hacs.zip.sha512 \
 && apk add --update --no-cache \
            iputils \
 && mkdir /hacs \
 && cd /hacs \
 && unzip /tmp/hacs.zip \
 && rm /tmp/hacs.zip /tmp/hacs.zip.sha512

EXPOSE 8123
VOLUME ["/config","/media"]

HEALTHCHECK --interval=15s --timeout=3s --start-period=5s \
        CMD [ "wget", "-qSO", "/dev/null", "http://127.0.0.1:8123" ]
