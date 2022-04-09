FROM homeassistant/home-assistant:2022.4.1

ARG HACS_VERSION=1.24.3

COPY run.sh /etc/services.d/home-assistant/run

ADD https://github.com/hacs/integration/releases/download/${HACS_VERSION}/hacs.zip \
    /tmp/hacs.zip

# Add `iputils` package for `ping` entity to work correctly.
# See: https://community.home-assistant.io/t/device-tracker-ping-entity-not-appearing/328005/9

RUN apk add --update --no-cache \
            iputils \
 && mkdir /hacs \
 && cd /hacs \
 && unzip /tmp/hacs.zip \
 && rm /tmp/hacs.zip

EXPOSE 8123
VOLUME ["/config"]

HEALTHCHECK --interval=20s --timeout=3s --start-period=5s --retries=3 \
        CMD [ "wget", "-qSO", "/dev/null", "http://localhost:8123" ]
