FROM haproxy:lts-alpine@sha256:3185af81d88b811997aa85f98e95b74435a821bf2438db600bb6514e468b79ab

LABEL org.opencontainers.image.source="https://github.com/statista-oss/proxy-router"
LABEL org.opencontainers.image.description="haproxy configurable through env vars for different routing strategies"

USER root
RUN apk add --no-cache socat

USER haproxy

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

