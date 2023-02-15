FROM scratch

ARG PLATFORM=epyc7002

ARG VERSION=7.1

ARG CDN=https://global.synologydownload.com

ADD ${CDN}/download/ToolChain/toolkit/${VERSION}/base/base_env-${VERSION}.txz /

ADD ${CDN}/download/ToolChain/toolkit/${VERSION}/${PLATFORM}/ds.${PLATFORM}-${VERSION}.env.txz /

ADD ${CDN}/download/ToolChain/toolkit/${VERSION}/${PLATFORM}/ds.${PLATFORM}-${VERSION}.dev.txz /

ADD rootfs /

ENTRYPOINT ["/usr/bin/bash"]
