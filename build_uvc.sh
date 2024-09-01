#!/bin/bash
set -xe
cd ${0%/*}/


PLATFORM=${PLATFORM:-apollolake}
TOOLKIT_VER=${TOOLKIT_VER:-7.1}
IMAGE=docker-syno-toolkit:$PLATFORM-$TOOLKIT_VER
# KSRC=$PWD/linux-4.4.x


docker build -t $IMAGE \
    --build-arg PLATFORM=$PLATFORM \
    --build-arg TOOLKIT_VER=$TOOLKIT_VER \
    .

docker run -it --rm -v "$KSRC":/src -v "$KSRC"/output:/output -e CONFIG_USB_VIDEO_CLASS=m $IMAGE compile-module drivers/media/usb/uvc
docker run -it --rm -v "$KSRC":/src -v "$KSRC"/output:/output $IMAGE compile-module drivers/media/v4l2-core
