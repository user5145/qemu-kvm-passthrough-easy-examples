#!/bin/bash
set -e
#
# ToDo
# 1. change img to existing image file.
# 
# You may want to change QEMU_AUDIO_DRV value to "alsa" to use alsa host driver instead of pulseaudio.
# QEMU_PA_SERVER is unnecessary then but QEMU_AUDIO_DAC_FIXED_FREQ may be if your sound cracks.
# Set it to value used by guest, for frequency equal to 44100 hz value is 44100.
# during 100% cpu usage your sound may crack so it is recommended to don't give all cpu power to guest

img=/home/$USER/vm.img &&
QEMU_AUDIO_DRV=pa &&
userId=$(id -u) &&
QEMU_PA_SERVER=/run/user/$userId/pulse/native &&

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
