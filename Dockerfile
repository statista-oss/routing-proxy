FROM haproxy:lts-alpine@sha256:fbfce01a9280b2e87acbbd8a61724a3a82bcd0b2d5c302f0c396c3ed91f88dd3

LABEL org.opencontainers.image.source="https://github.com/statista-oss/proxy-router"
LABEL org.opencontainers.image.description="haproxy configurable through env vars for different routing strategies"

USER root
RUN apk add --no-cache socat

USER haproxy

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

