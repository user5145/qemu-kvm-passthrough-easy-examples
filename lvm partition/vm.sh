#!/bin/bash
#
# ToDo
# 1. change drive file to existing lvm volume.
img= /dev/mapper/group-volume &&

qemu-system-x86_64 -enable-kvm -M pc-q35-2.10 -m 2000 \
    -cpu host \
    -smp 1,sockets=1,cores=1,threads=1 \
    -vga qxl \
    -net none \
    -rtc base=localtime \
    -soundhw hda \
    -usbdevice tablet \
    -drive file=$img,if=virtio,id=disk1,format=raw,cache=none,media=disk \
    -spice port=5900,disable-ticketing

