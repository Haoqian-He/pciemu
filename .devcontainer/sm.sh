# .qemu_config : Configurations for launching QEMU
#
# Copyright (c) 2023 Luiz Henrique Suraty Filho <luiz-dev@suraty.com>
#
# SPDX-License-Identifier: GPL-2.0
#

# QEMU TCP Address and Ports
QEMU_TCP_ADDRESS=127.0.0.1
QEMU_TCP_PORT_SSH=49124
QEMU_TCP_PORT_MONITOR=6873

# Repository information
REPOSITORY_DIR=$(git rev-parse --show-toplevel)
REPOSITORY_NAME=$(basename $REPOSITORY_DIR)

# Drive Files
QEMU_DRIVE_FILE_FEDORA=$REPOSITORY_DIR/.devcontainer/images/fedora.qcow2
# QEMU_DRIVE_FILE_FEDORA=$REPOSITORY_DIR/.devcontainer/images/pciemu.qcow2

# QEMU executable
QEMU_EXEC=$REPOSITORY_DIR/qemu/build/qemu-system-x86_64

# Get the correct accelerator
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	QEMU_ACCEL=kvm
elif [[ "$OSTYPE" == "darwin"* ]]; then
	QEMU_ACCEL=hvf
else
	echo "Unsupported OS"
fi

# QEMU Launch Default Aliases
#
# log errors : -d guest_errors -D $REPOSITORY_DIR/errors.log
#alias qemu_fedora="\
# 输出在终端  -serial mon:stdio\
# 输出在文件 -serial file:qemu.log\

qemu_fedora="\
 $QEMU_EXEC\
  -accel $QEMU_ACCEL\
  -cpu host\
  -smp 32\
  -m 32G\
  -display none\
  -device pciemu,id=pciemu1\
  -device virtio-net,netdev=vmnic\
  -netdev user,id=vmnic,hostfwd=tcp:$QEMU_TCP_ADDRESS:$QEMU_TCP_PORT_SSH-:22\
  -drive file=$QEMU_DRIVE_FILE_FEDORA,if=virtio\
  -virtfs local,path=$REPOSITORY_DIR,security_model=mapped,mount_tag=hostdir\
  -serial mon:stdio\
  -fw_cfg name=opt/repositoryname,string=$REPOSITORY_NAME\
  -monitor tcp:$QEMU_TCP_ADDRESS:$QEMU_TCP_PORT_MONITOR,server,nowait"
  #-monitor tcp:$QEMU_TCP_ADDRESS:$QEMU_TCP_PORT_MONITOR,server,nowait > qemu.log 2>&1 &"
  # -serial file:qemu.log\

eval $qemu_fedora
