# jetson nano

detect i2c devices
```sh
i2cdetect -y -r 1
```


## Kernel building

toolchain 
```sh
JETSON_NANO_KERNEL_SOURCE=$(pwd)

cd $JETSON_NANO_KERNEL_SOURCE
TOOLCHAIN_PREFIX=/home/lukasz/workspace/fotoacc/jetson_tools/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
TEGRA_KERNEL_OUT=$JETSON_NANO_KERNEL_SOURCE/build
KERNEL_MODULES_OUT=$JETSON_NANO_KERNEL_SOURCE/modules

make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra tegra_defconfig

make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra -j4 --output-sync=target zImage
make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra -j4 --output-sync=target modules
make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra -j4 --output-sync=target dtbs
make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra INSTALL_MOD_PATH=$KERNEL_MODULES_OUT modules_install
```



in case of error
```sh
/usr/bin/ld: scripts/dtc/dtc-parser.tab.o:(.bss+0x10): multiple definition of `yylloc'; scripts/dtc/dtc-lexer.lex.o:(.bss+0x0): first defined here
collect2: error: ld returned 1 exit status

```
fix:
```sh
sed -i 's/^YYLTYPE yylloc;$/extern YYLTYPE yylloc;/'  kernel/kernel-4.9/scripts/dtc/dtc-lexer.l
```

edit dtc-lexer.l (add extern)
edit dtc-parser.tab.c_shipped (add second extern)

sudo dnf install vim-common