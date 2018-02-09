#!/bin/bash
set -e
#
# You can force guest to create a second partition table inside passed lvm partition without affecting your host and treat it as disk inside guest.
#
# TODO
# 1. change drive file to existing lvm volume.

img=/dev/mapper/group-volume &&
#do if mounted
if mount | grep $img > /dev/null; then
    umount $img &&
    sync
fi &&

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

