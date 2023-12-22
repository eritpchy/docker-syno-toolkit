FROM alpine:3.17 AS builder

RUN apk add -U xz && \
    mkdir -p /toolkit

ARG PLATFORM=epyc7002
ARG TOOLKIT_VER=7.2
ARG CDN=https://global.synologydownload.com/download

RUN set -x && \
    wget ${CDN}/ToolChain/toolkit/${TOOLKIT_VER}/${PLATFORM}/ds.${PLATFORM}-${TOOLKIT_VER}.env.txz && \
    md5sum ds.${PLATFORM}-${TOOLKIT_VER}.env.txz >> /toolkit/md5sum.txt && \
    tar -Jxvf ds.${PLATFORM}-${TOOLKIT_VER}.env.txz -C /toolkit && \
    wget ${CDN}/ToolChain/toolkit/${TOOLKIT_VER}/${PLATFORM}/ds.${PLATFORM}-${TOOLKIT_VER}.dev.txz && \
    md5sum ds.${PLATFORM}-${TOOLKIT_VER}.dev.txz >> /toolkit/md5sum.txt && \
    tar -Jxvf ds.${PLATFORM}-${TOOLKIT_VER}.dev.txz -C /toolkit

FROM ubuntu:22.04

RUN apt update && \
    apt-get install -y \
        git \
        fakeroot \
        bc \
        bison \
        build-essential \
        flex \
        iproute2 \
        libelf-dev \
        libssl-dev \
        ncurses-dev \
        tree \
        vim \
        xz-utils

LABEL org.opencontainers.image.description "Synology toolkit to build kernel modules"

COPY --from=builder /toolkit /toolkit

ADD rootfs /

ARG PLATFORM=epyc7002
ARG TOOLKIT_VER=7.2

ENV PLATFORM=${PLATFORM}
ENV TOOLKIT_VER=${TOOLKIT_VER}

ENV ARCH=x86_64
ENV CC="x86_64-pc-linux-gnu-gcc"
ENV CXX="x86_64-pc-linux-gnu-g++"
ENV LD="x86_64-pc-linux-gnu-ld"
ENV CXX="x86_64-pc-linux-gnu-g++"
# ENV OBJCOPY="x86_64-pc-linux-gnu-objcopy"

ENV PATH=/toolkit/usr/local/x86_64-pc-linux-gnu/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/core_perl/:/usr/syno/bin
ENV CROSS_COMPILE="/toolkit/usr/local/x86_64-pc-linux-gnu/bin/x86_64-pc-linux-gnu-"

ENV KSRC="/toolkit/usr/local/x86_64-pc-linux-gnu/x86_64-pc-linux-gnu/sys-root/usr/lib/modules/DSM-${TOOLKIT_VER}/build"
ENV LINUX_SRC="/toolkit/usr/local/x86_64-pc-linux-gnu/x86_64-pc-linux-gnu/sys-root/usr/lib/modules/DSM-${TOOLKIT_VER}/build"

RUN sed -i "s#PATH='#PATH='/toolkit/usr/local/x86_64-pc-linux-gnu/bin:#" /root/.bashrc

ENTRYPOINT ["/usr/bin/do.sh"]
