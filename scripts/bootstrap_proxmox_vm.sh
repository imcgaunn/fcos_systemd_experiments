#!/bin/bash
set -o pipefail
set -o nounset
set -o errexit

CONFIG="$1"
source "vars/$CONFIG"

qm create ${VM_ID} --name ${NAME} \
  --cores ${CPUS} \
  --memory ${MEMORY} \
  --net0 virtio,bridge=vmbr0 \
  --scsihw virtio-scsi-pci
qm set ${VM_ID} --scsi0 "${ROOT_STORAGE}:0,import-from=/var/coreos/images/${QCOW}"
qm resize ${VM_ID} scsi0 +${ROOT_DISK_SIZE}
# allocate an additional volume for vm data
pvesm alloc ${DATA_STORAGE} ${VM_ID} ${DATA_VOLUME} ${DATA_DISK_SIZE} --format raw
qm set ${VM_ID} --scsi1 "${DATA_STORAGE}:${DATA_VOLUME}"

# add cloud-init drive to deliver ignition config
qm set ${VM_ID} --ide2 ${ROOT_STORAGE}:cloudinit
qm set ${VM_ID} --boot order=scsi0
qm set ${VM_ID} --serial0 socket --vga serial0
qm set ${VM_ID} --cicustom vendor=${ROOT_STORAGE}:snippets/${IGN}
qm set ${VM_ID} --ciupgrade 0

# make sure guest agent is enabled
qm set ${VM_ID} --agent enabled=1
