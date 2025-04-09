# Makefile for the kernel module
#
# Copyright (c) 2023 Luiz Henrique Suraty Filho <luiz-dev@suraty.com>
#
# SPDX-License-Identifier: GPL-2.0
#

obj-m += pciemu.o
pciemu-objs += pciemu_module.o pciemu_dma.o pciemu_irq.o
# ccflags-y=-I/hostdir/include
# ccflags-y=-I/hostdir/include -I/root/qemu-code/pciemu/include -I/root/qemu-code/pciemu/607/usr/include
ccflags-y=-I/hostdir/include -I/root/qemu-code/pciemu/607/usr/include -I/root/qemu-code/pciemu/include

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean

# in 6.11 kernel
local_clean:
	make -C /root/qemu-code/pciemu/607/usr/src/kernels/6.0.7-301.fc37.x86_64 M=$(PWD) clean

local_all:
	make -C /root/qemu-code/pciemu/607/usr/src/kernels/6.0.7-301.fc37.x86_64 M=$(PWD) modules

