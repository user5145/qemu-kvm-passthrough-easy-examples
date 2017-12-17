#!/bin/bash

# gpu should works even in bios out of box if system and uefi let it
# kvm=off,hv_time,hv_relaxed,hv_vapic,hv_spinlocks=0x1fff,hv_vendor_id=Nvidia43FIX is for nvidia 43 error and is SUFFICIENT, tested without driver and with 388.59
#
# TODO
# 1. to set -usbdevice use command lsusb and rewrite proper id after host
# 2. specify your ovmf uefi localization (e.g. /usr/share/edk2/ovmf/OVMF_CODE.fd) and point it as bios (-drive and -bios)
# 3. host argument for -device should match to a gpu, which you intend to pass. Check with lspci -nn command
# 4. addresses used there shouldn't be used by the system, replace it with random hex numbers
# 5. add file path to -drive which should act as hdd/ssd

qemu-system-x86_64 -M pc-q35-2.8 -m 2000 \
    -bios OVMF_CODE.fd \
    -cpu host,kvm=off,hv_time,hv_relaxed,hv_vapic,hv_spinlocks=0x1fff,hv_vendor_id=Nvidia43FIX \
    -smp 1,sockets=1,cores=1,threads=1 \
    -vga none \
    -net none \
    -rtc base=localtime \
    -soundhw none \
    -drive if=pflash,format=raw,readonly,file=/usr/share/edk2/ovmf/OVMF_CODE.fd \
    -device ioh3420,bus=pcie.0,addr=1c.0,multifunction=on,port=1,chassis=1,id=root.1 \
    -device vfio-pci,host=01:00.0,bus=pcie.0,addr=08.0,x-vga=on,multifunction=on \
    -device vfio-pci,host=01:00.1,bus=pcie.0,addr=08.1 \
    -device virtio-scsi-pci,id=scsi \
    -drive file=/home/$USER/images/vm.img,id=vdisk,format=raw,cache=writethrough,if=virtio,index=2,media=disk,format=raw \
    -device usb-ehci,id=ehci \
    -usb -usbdevice host:1aaa:0001 \

