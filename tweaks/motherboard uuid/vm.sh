#!/bin/bash
set -e
#
# ToDo
# 1. change img to existing image file.
# 2. specify uefi code and vars variable, you may want to store uefi vars file to keep your boot settings

img=/home/$USER/vm.img &&
bios_code="/usr/share/ovmf/x64/OVMF_CODE.fd" &&
bios_vars="/usr/share/ovmf/x64/OVMF_VARS.fd" &&
cp $bios_vars /tmp/qemu_bios_vars &&

#do if mounted
if mount | grep $img > /dev/null; then
    umount $img &&
    sync
fi &&

qemu-system-x86_64 -enable-kvm -M pc-q35-2.10 -m 2000 \
    -cpu host \
    -uuid 00000000-0000-0000-0000-000000000000 \
    -smp 1,sockets=1,cores=1,threads=1 \
    -drive if=pflash,format=raw,readonly,file=$bios_code \
    -drive if=pflash,format=raw,file=/tmp/qemu_bios_vars \
    -vga qxl \
    -net none \
    -rtc base=localtime \
    -soundhw hda \
    -usbdevice tablet \
    -drive file=$img,if=virtio,id=disk1,format=raw,cache=none,media=disk \
    -spice port=5900,disable-ticketing
