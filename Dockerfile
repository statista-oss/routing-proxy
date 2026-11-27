FROM haproxy:lts-alpine@sha256:8aa6458a9d22a8364a2d2ee9ce93de0cc4a2789e3cf63f0b44adc972863724d7

LABEL org.opencontainers.image.source="https://github.com/statista-oss/proxy-router"
LABEL org.opencontainers.image.description="haproxy configurable through env vars for different routing strategies"

USER root
RUN apk upgrade --no-cache && apk add --no-cache socat

USER haproxy

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

