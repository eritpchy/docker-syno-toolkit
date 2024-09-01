# docker-syno-toolkit

Synology toolkit to build kernel modules (UVC)

## Usage

- Download your Synology NAS kernel source from [Synology NAS GPL Source](https://archive.synology.com/download/ToolChain/Synology%20NAS%20GPL%20Source/).
- For example, the file might be `linux-4.4.x.txz` (`apollolake`)
- Unzip the source to the project root.
- Run the build script:

    ```sh
    PLATFORM={nas_platform} TOOLKIT_VER={nas_sys_ver} KSRC={kernel_src_path} ./build_uvc.sh
    ```

    Example:

    ```sh
    PLATFORM=apollolake TOOLKIT_VER=7.1 KSRC=$PWD/linux-4.4.x ./build_uvc.sh
    ```

- Your kernel modules will be located in `{kernel_src_path}/output`
- Upload `*.ko` files to your NAS at `/lib/modules/`
- Upload `uvcvideo-modules.sh` to your NAS at `/usr/local/etc/rc.d/uvcvideo-modules.sh`
- On your NAS, make the script executable:

    ```sh
    chmod +x /usr/local/etc/rc.d/uvcvideo-modules.sh
    ```

- Enjoy!
