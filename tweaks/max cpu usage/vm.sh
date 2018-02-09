#!/bin/bash
set -e
#
# ToDo
# 1. change img to existing image file.
# 2. set proper percentage. cpulimit increase max value about 100 per every thread in host cpu, so for one cpu with 2 threads max value is 200.

img=/home/$USER/vm.img &&
#do if mounted
if mount | grep $img > /dev/null; then
    umount $img &&
    sync
fi &&
percentage=190 &&

cpulimit -l $percentage qemu-system-x86_64 -enable-kvm -M pc-q35-2.10 -m 2000 \
    -cpu host \
    -smp 2,sockets=1,cores=2,threads=1 \
    -vga qxl \
    -net none \
    -rtc base=localtime \
    -soundhw hda \
    -usbdevice tablet \
    -drive file=$img,if=virtio,id=disk1,format=raw,cache=none,media=disk \
    -spice port=5900,disable-ticketing
