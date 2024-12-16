FROM haproxy:lts-alpine

USER root
RUN apk add --no-cache curl socat

USER haproxy

# defaults
ENV PERCENTAGE_NEW=0
ENV PERCENTAGE_OLD=100

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

