ARG BUILD_FROM=hassioaddons/base:8.0.1
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apk -U add \
        git \
        build-base \
        autoconf \
        automake \
        libtool \
        alsa-lib-dev \
        libdaemon-dev \
        popt-dev \
        libressl-dev \
        soxr-dev \
        avahi-dev \
        libconfig-dev \
 && cd /root \
 && git clone -b development --single-branch https://github.com/mikebrady/shairport-sync.git \
 && cd shairport-sync \
 && autoreconf -i -f \
 && ./configure \
        --with-alsa \
        --with-pipe \
        --with-avahi \
        --with-ssl=openssl \
        --with-soxr \
        --with-mqtt-client
        --with-metadata \
 && make \
 && make install \
 && cd / \
 && apk --purge del \
        git \
        build-base \
        autoconf \
        automake \
        libtool \
        alsa-lib-dev \
        libdaemon-dev \
        popt-dev \
        libressl-dev \
        soxr-dev \
        avahi-dev \
        libconfig-dev \
 && apk add \
        dbus \
        alsa-lib \
        alsa-plugins-pulse \
        libdaemon \
        popt \
        libressl \
        soxr \
        avahi \
        libconfig \
 && rm -rf \
        /etc/ssl \
        /var/cache/apk/* \
        /lib/apk/db/* \
        /root/shairport-sync
        /var/run/dbus.pid

# Copy root filesystem
COPY rootfs /

#remove
ENTRYPOINT rm -f /var/run/dbus.pid

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="modified shairport Sync" \
    io.hass.description="modifiedShairport Sync for Hass.io" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="lastbest"
