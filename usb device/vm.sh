#!/bin/bash
#
# ToDo
# 1. change img to existing file image.
# 2. check usb device id (e.g. with lsusb) and set it as usbId

img= /home/$USER/vm.img &&
usbId= 1d1b:0001 &&

qemu-system-x86_64 -enable-kvm -M pc-q35-2.10 -m 2000 \
    -cpu host \
    -smp 1,sockets=1,cores=1,threads=1 \
    -vga qxl \
    -net none \
    -rtc base=localtime \
    -soundhw hda \
    -usbdevice tablet \
    -drive file=$img,if=virtio,id=disk1,format=raw,cache=none,media=disk \
    -usb -usbdevice host:$usbId \
    -spice port=5900,disable-ticketing

