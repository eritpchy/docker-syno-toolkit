FROM alpine:3.17 AS builder

RUN apk add -U xz && \
    mkdir /toolkit

ARG PLATFORM=epyc7002
ARG TOOLKIT_VER=7.1
ARG CDN=https://global.synologydownload.com

RUN set -x && \
    wget ${CDN}/download/ToolChain/toolkit/${TOOLKIT_VER}/base/base_env-${TOOLKIT_VER}.txz && \
    tar -Jxvf base_env-${TOOLKIT_VER}.txz -C /toolkit && \
    wget ${CDN}/download/ToolChain/toolkit/${TOOLKIT_VER}/${PLATFORM}/ds.${PLATFORM}-${TOOLKIT_VER}.env.txz && \
    tar -Jxvf ds.${PLATFORM}-${TOOLKIT_VER}.env.txz -C /toolkit && \
    wget ${CDN}/download/ToolChain/toolkit/${TOOLKIT_VER}/${PLATFORM}/ds.${PLATFORM}-${TOOLKIT_VER}.dev.txz && \
    tar -Jxvf ds.${PLATFORM}-${TOOLKIT_VER}.dev.txz -C /toolkit

FROM scratch

COPY --from=builder /toolkit /

ADD rootfs /

ARG PLATFORM
ARG TOOLKIT_VER

ENV PLATFORM=${PLATFORM}
ENV TOOLKIT_VER=${TOOLKIT_VER}

ENV ARCH=x86_64
ENV CC="x86_64-pc-linux-gnu-gcc"
ENV CXX="x86_64-pc-linux-gnu-g++"
ENV LD="x86_64-pc-linux-gnu-ld"
ENV CXX="x86_64-pc-linux-gnu-g++"
# ENV OBJCOPY="x86_64-linux-gnu-objcopy"

ENV PATH=/usr/local/x86_64-pc-linux-gnu/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/core_perl/:/usr/syno/bin
ENV KSRC="/usr/local/x86_64-pc-linux-gnu/x86_64-pc-linux-gnu/sys-root/usr/lib/modules/DSM-${TOOLKIT_VER}/build"
ENV LINUX_SRC="/usr/local/x86_64-pc-linux-gnu/x86_64-pc-linux-gnu/sys-root/usr/lib/modules/DSM-${TOOLKIT_VER}/build"
ENV CROSS_COMPILE="/usr/local/x86_64-pc-linux-gnu/bin/x86_64-pc-linux-gnu-"

RUN sed -i "s#PATH='#PATH='/usr/local/x86_64-pc-linux-gnu/bin:#" /root/.bashrc

ENTRYPOINT ["/usr/bin/bash"]
