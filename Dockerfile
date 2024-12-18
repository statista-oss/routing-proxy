FROM haproxy:lts-alpine

LABEL org.opencontainers.image.source=https://github.com/statista-oss/proxy-router
LABEL org.opencontainers.image.description="haproxy configurable through env vars for different routing strategies"

USER root
RUN apk add --no-cache socat

USER haproxy

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

