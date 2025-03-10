FROM homeassistant/home-assistant:2025.3.1

ARG HACS_VERSION=2.0.5
ARG HACS_SHA_512=fcb91d2df1ee07234fbd13b1a859181c0c64022b04819503cab0980bc7fb345c0709682937cb086a76ef7cb01a3ed9fe1c28cf1edbbd4620a8875fb6fa7e7a37

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
