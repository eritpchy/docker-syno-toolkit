#!/bin/sh

case $1 in
    start)
        echo "Loading uvcvideo modules..."
        insmod /lib/modules/videodev.ko 
        insmod /lib/modules/videobuf2-core.ko
        insmod /lib/modules/v4l2-common.ko
        insmod /lib/modules/videobuf2-v4l2.ko
        insmod /lib/modules/tuner.ko 
        insmod /lib/modules/videobuf2-memops.ko
        insmod /lib/modules/videobuf2-vmalloc.ko
        insmod /lib/modules/uvcvideo.ko
        ;;
    stop)
        echo "Unloading uvcvideo modules..."
        rmmod uvcvideo
        rmmod videobuf2-vmalloc
        rmmod videobuf2-memops
        rmmod tuner
        rmmod videobuf2-v4l2
        rmmod v4l2-common
        rmmod videobuf2-core
        rmmod videodev
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac

exit 0