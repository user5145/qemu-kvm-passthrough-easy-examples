#!/bin/bash
set -e
#
#this magic should unbind efifb
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind
#
#
# gpu should works even during POST out of box if host system and uefi let it to
# 
#
# TODO
# 1. change img to existing image file.
# 2. specify uefi code and vars variable, you may want to store uefi vars file to keep your boot settings
# 3. device you want to pass has to use vfio driver
# 4. host argument for -device should match to a gpu, which you want to pass. Check with lspci -nn command
# 5. addresses in device used there shouldn't be already used by your system
# 6. add path to file which should act as storage to -drive
# 7. don't use spice/vnc and emulated vga, it can be detected by nvidia driver
# 8. set usb device to control guest. check id with lsusb.

img=/home/$USER/vm.img &&
bios_code="/usr/share/edk2/ovmf/OVMF_CODE.fd" &&
bios_vars="/usr/share/edk2/ovmf/OVMF_VARS.fd" &&
gpuId=1:00.0 &&
gpuAudioId=1:00.1 &&
usbId1=1d1b:0001 &&
cp $bios_vars /tmp/qemu_bios_vars &&

#do if mounted
if mount | grep $img > /dev/null; then
    umount $img &&
    sync
fi &&

qemu-system-x86_64 -enable-kvm -M pc-q35-2.10 -m 2000 \
    -cpu host,kvm=off,hv_time,hv_relaxed,hv_vapic,hv_spinlocks=0x1fff,hv_vendor_id=Nvidia43FIX \
    -smp 1,sockets=1,cores=1,threads=1 \
    -drive if=pflash,format=raw,readonly,file=$bios_code \
    -drive if=pflash,format=raw,file=/tmp/qemu_bios_vars \
    -vga none \
    -net none \
    -rtc base=localtime \
    -soundhw hda \
    -device ioh3420,bus=pcie.0,addr=1c.0,multifunction=on,port=1,chassis=1,id=root.1 \
    -device vfio-pci,host=$gpuId,bus=pcie.0,addr=08.0,x-vga=on,multifunction=on \
    -device vfio-pci,host=$gpuAudioId,bus=pcie.0,addr=08.1 \
    -drive file=$img,if=virtio,id=disk1,format=raw,cache=none,media=disk \
    -usb -usbdevice host:$usbId1
