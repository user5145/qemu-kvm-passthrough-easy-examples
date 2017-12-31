#!/bin/bash
set -e
#
# ToDo
# 1. change img to existing file image.
# 2. specify uefi code and vars variable, you may want to store uefi vars file to keep your boot settings

img= /home/$USER/vm.img &&
bios_code= "/usr/share/edk2/ovmf/OVMF_CODE.fd" &&
bios_vars= "/usr/share/edk2/ovmf/OVMF_VARS.fd" &&
cp $bios_vars /tmp/qemu_bios_vars &&

qemu-system-x86_64 -enable-kvm -M pc-q35-2.10 -m 2000 \
    -cpu host \
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
