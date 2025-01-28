FROM homeassistant/home-assistant:2025.1.4

ARG HACS_VERSION=2.0.4
ARG HACS_SHA_512=e2dcd96dc9ed666eee198880bcc6aba57514f0551f2a93105164771450680ccbbf7d5853712d789c402b8b8fd48b1b5cbea408c5ed32e14b2e004c229ca41265

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
