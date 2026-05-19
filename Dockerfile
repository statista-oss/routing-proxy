FROM haproxy:lts-alpine@sha256:4293e7e02c70e143778c86b4916f1b89e04f7a9221534b9abf6cace218c6b95f

LABEL org.opencontainers.image.source="https://github.com/statista-oss/proxy-router"
LABEL org.opencontainers.image.description="haproxy configurable through env vars for different routing strategies"

USER root
RUN apk add --no-cache socat

USER haproxy

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

