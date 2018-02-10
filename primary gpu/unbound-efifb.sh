#!/bin/bash
set -e
#you can run this script or add video=efifb:off as a kernel parameter

#this magic should unbind efifb
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

echo "done"
