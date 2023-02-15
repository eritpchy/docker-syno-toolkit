FROM alpine:3.17 AS builder

ARG PLATFORM=epyc7002

ARG VERSION=7.1

ARG CDN=https://global.synologydownload.com

RUN apk add -U xz && \
    mkdir /toolkit && \
    wget ${CDN}/download/ToolChain/toolkit/${VERSION}/base/base_env-${VERSION}.txz && \
    tar -Jxvf base_env-${VERSION}.txz -C /toolkit && \
    wget ${CDN}/download/ToolChain/toolkit/${VERSION}/${PLATFORM}/ds.${PLATFORM}-${VERSION}.env.txz && \
    tar -Jxvf ds.${PLATFORM}-${VERSION}.env.txz -C /toolkit && \
    wget ${CDN}/download/ToolChain/toolkit/${VERSION}/${PLATFORM}/ds.${PLATFORM}-${VERSION}.dev.txz && \
    tar -Jxvf ds.${PLATFORM}-${VERSION}.dev.txz -C /toolkit

FROM scratch

COPY --from=builder /toolkit /

ADD rootfs /

ENTRYPOINT ["/usr/bin/bash"]
