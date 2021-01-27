# Kernel buildin jetson nano

based on 
https://developer.ridgerun.com/wiki/index.php?title=Jetson_Nano/Development/Building_the_Kernel_from_Source

```
```

## Download and install Toolchain
## Download the kernel sources
## Setup environment
at the bottom of `~/.bashrc` append lines
```

export TOOLCHAIN_PREFIX=$HOME/l4t-gcc/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
export JETSON_NANO_KERNEL_SOURCE="/home/jetson/l4t-gcc/Linux_for_Tegra/source/public"
export NANO_DTS_PATH=$JETSON_NANO_KERNEL_SOURCE/hardware/nvidia/platform/t210/porg/kernel-dts

export TEGRA_KERNEL_OUT=$JETSON_NANO_KERNEL_SOURCE/build
export KERNEL_MODULES_OUT=$JETSON_NANO_KERNEL_SOURCE/modules
export DTB=tegra210-p3448-0000-p3449-0000-a02.dtb

export NVIDIA_SDK_MANAGER=$HOME/nvidia/nvidia_sdk/
export JETPACK_PATH=$NVIDIA_SDK_MANAGER/JetPack_4.4_Linux_JETSON_NANO_DEVKIT/Linux_for_Tegra/


```

```
source ~/.bashrc
```
## Setup veye camera driver imx307
```
cd ~
https://github.com/veyeimaging/nvidia_jetson_veye_bsp.git

cp -v ~/nvidia_jetson_veye_bsp/drivers_source/cam_drv_src/* $JETSON_NANO_KERNEL_SOURCE/kernel/nvidia/drivers/media/i2c/

cp -v ~/nvidia_jetson_veye_bsp/drivers_source/kernel_veyecam_config_r32.4.4 $JETSON_NANO_KERNEL_SOURCE/kernel/kernel-4.9/arch/arm64/configs/tegra_veyecam_defconfig

cp -v ~/nvidia_jetson_veye_bsp/Nano/JetPack_4.4_Linux_JETSON_NANO_DEVKIT/dts\ dtb/common/t210/* -r $NANO_DTS_PATH/

cp -v ~/nvidia_jetson_veye_bsp/Nano/JetPack_4.4_Linux_JETSON_NANO_DEVKIT/dts\ dtb/CS-MIPI-IMX307/tegra210-porg-plugin-manager.dtsi -r $NANO_DTS_PATH/porg/kernel-dts/porg-plugin-manager
```



## Compile kernel and dtb

### Configure kernel
```
cd $JETSON_NANO_KERNEL_SOURCE
```
standard config:
```
make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra CROSS_COMPILE=${TOOLCHAIN_PREFIX} tegra_defconfig
```

veyecam config:
```
make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra CROSS_COMPILE=${TOOLCHAIN_PREFIX} tegra_veyecam_defconfig
```

menuconfig:
```
make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra CROSS_COMPILE=${TOOLCHAIN_PREFIX} menuconfig
```

#### Enable sierra wireless EM7455
Execute `make menuconfig` and goto `Device Drivers"->"USB support"->"USB Serial Converter support"->"USB Qualcomm Serial modem` press `Y` to enable. Then Save config and exit.

#### Build kernel
for 48 thread cpu:
```
make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra CROSS_COMPILE=${TOOLCHAIN_PREFIX} -j48 --output-sync=target zImage

make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra CROSS_COMPILE=${TOOLCHAIN_PREFIX} -j48 --output-sync=target modules

make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra CROSS_COMPILE=${TOOLCHAIN_PREFIX} -j48 --output-sync=target dtbs

make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra INSTALL_MOD_PATH=$KERNEL_MODULES_OUT modules_install
```



## Flash Jetson
```
cd $JETPACK_PATH

# Copy kernel generated
cp -v $JETSON_NANO_KERNEL_SOURCE/build/arch/arm64/boot/Image kernel/
# Copy device tree generated
cp -v $JETSON_NANO_KERNEL_SOURCE/build/arch/arm64/boot/dts/${DTB} kernel/dtb/
```

### Create default user skip GUI setup

https://developer.ridgerun.com/wiki/index.php?title=NVIDIA_Jetson_Hacks#Create_default_user_in_the_file_system_.28Skip_GUI_setup_in_JetPack_.3E.3D_4.2.29

copy this script [l4t_create_default_user.sh](l4t_create_default_user.sh) to $JETPACK_PATH
```
sudo chmod +x l4t_create_default_user.sh
sudo ./l4t_create_default_user.sh -u jetson -p jetson
```

### Flash
devkit:

32GB sd card:
```
sudo ./flash.sh -S 27GiB jetson-nano-qspi-sd mmcblk0p1
```

64GB sd card:
```
sudo ./flash.sh -S 58GiB jetson-nano-qspi-sd mmcblk0p1 
```
