#!/bin/bash
set -e
#
# ToDo
# 1. change img to existing image file.
# 2. set proper nice and ionice. for nice the highest priority is -n -20, lowest -n 20, os default -n 0, nice default 10. for negative priorities root privilages are required.
# 3. set ionice, be cautious high value can break your system. For more info read man.

img=/home/$USER/vm.img &&

ionice -c2 -n1 \
nice -n -10 \
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
