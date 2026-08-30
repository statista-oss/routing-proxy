FROM haproxy:lts-alpine@sha256:c0afc4864dca9c68694cd1290433f0ee79b5c55be80f6745a165ffe373b9a564

LABEL org.opencontainers.image.source="https://github.com/statista-oss/proxy-router"
LABEL org.opencontainers.image.description="haproxy configurable through env vars for different routing strategies"

USER root
RUN apk add --no-cache socat

USER haproxy

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

