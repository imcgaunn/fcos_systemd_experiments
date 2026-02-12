#!/bin/bash
set -o pipefail
set -o nounset
set -o errexit

VM_ID=150
NAME=nexus-fcos
QCOW=fedora-coreos-43.20260119.3.1-proxmoxve.x86_64.qcow2
IGN=simple.ign
ROOT_STORAGE=coreos
DATA_STORAGE=local-lvm
DATA_VOLUME=vm-${VM_ID}-nexus-fcos-data-0
CPUS=2
MEMORY=4096
ROOT_DISK_SIZE=10G
DATA_DISK_SIZE=64G

qm create ${VM_ID} --name ${NAME} \
    --cores ${CPUS} \
    --memory ${MEMORY} \
    --net0 virtio,bridge=vmbr0 \
    --scsihw virtio-scsi-pci
qm set ${VM_ID} --scsi0 "${ROOT_STORAGE}:0,import-from=/var/coreos/images/${QCOW}"
qm resize ${VM_ID} scsi0 +${ROOT_DISK_SIZE}

pvesm alloc ${DATA_STORAGE} ${VM_ID} ${DATA_VOLUME} ${DATA_DISK_SIZE} --format raw
qm set ${VM_ID} --scsi1 "${DATA_STORAGE}:${DATA_VOLUME}"

# add cloud-init drive to deliver configuratoin
qm set ${VM_ID} --ide2 ${ROOT_STORAGE}:cloudinit
qm set ${VM_ID} --boot order=scsi0
qm set ${VM_ID} --serial0 socket --vga serial0
qm set ${VM_ID} --cicustom vendor=${ROOT_STORAGE}:snippets/simple-user-persistentdata.ign
qm set ${VM_ID} --ciupgrade 0