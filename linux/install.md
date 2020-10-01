
## Fix grub not showing up for dual boot with win10

```
sudo apt update
sudo apt install grub-efi grub2-common grub-customizer -y
sudo grub-install
sudo cp /boot/grub/x86_64-efi/grub.efi /boot/efi/EFI/pop/grubx64.efi
sudo grub-customizer
```

go to file->change enviorment
change OUTPUT_FILE to `/boot/efi/EFI/pop/grub.cfg`
set checkbox **save this configuration**

save update
```
sudo reboot
```

## Gnome tweaks

```
sudo apt install gnome-tweaks -y
```

