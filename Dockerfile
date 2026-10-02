FROM haproxy:lts-alpine@sha256:7af8255207ee9964ccb4eec8ce4b7a40b777769665e3ae83897fb01b24d8a43a

LABEL org.opencontainers.image.source="https://github.com/statista-oss/proxy-router"
LABEL org.opencontainers.image.description="haproxy configurable through env vars for different routing strategies"

USER root
RUN apk add --no-cache socat

USER haproxy

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

