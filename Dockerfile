ARG BUILD_FROM=hassioaddons/base:8.0.1
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN cd /config \
 && dir \
