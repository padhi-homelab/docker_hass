FROM homeassistant/home-assistant:2025.1.2

ARG HACS_VERSION=2.0.3
ARG HACS_SHA_512=d1fd7ce7b298d72f8f1d8809c9d7dac081610a01445c98b654696005f1ddec47dacc72f8b938b03c1187ad2b21bc6bb8a00538eb9b84f95ed8d234a0ce004ecd

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
