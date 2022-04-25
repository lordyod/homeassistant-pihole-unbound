ARG BUILD_FROM
FROM $BUILD_FROM
COPY install.sh /install.sh
RUN mkdir -p /etc/services.d/unbound    \
    && mkdir -p /data/pihole            \
    && mkdir -p /data/dnsmasq.d         \
    && ln -sf /data/pihole /etc/pihole  \
    && ln -sf /data/dnsmasq.d /etc/dnsmasq.d
RUN /install.sh                         \
    && apk update                       \
    && apk add unbound
COPY lighttpd-external.conf /etc/lighttpd/external.conf 
COPY unbound-pihole.conf /etc/unbound/unbound.conf.d/pi-hole.conf
COPY 99-edns.conf /etc/dnsmasq.d/99-edns.conf
COPY unbound-run /etc/services.d/unbound/run

ENTRYPOINT ./s6-init

