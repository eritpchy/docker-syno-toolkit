# docker-syno-toolkit

Synology toolkit to build kernel modules

## Usage

```
image=ghcr.io/jim3ma/docker-syno-toolkit:epyc7002-7.2

# kernel source code
kernel=/path/to/kernel

# path to modules
target=drivers/net/ethernet/intel/igc

docker run -it --rm \
    -v "$kernel":/src \
    -v "$kernel"/output:/output \
    $image compile-module $target
```
