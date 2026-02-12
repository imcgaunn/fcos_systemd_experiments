#!/bin/zsh
set -o pipefail
set -o errexit
set -o nounset

SCRIPT_DIR="${0:A:h}"
IMAGES_DIR="${SCRIPT_DIR}/../images"
STREAM="stable"
ARCH="x86_64"

mkdir -p "$IMAGES_DIR"
podman run --pull=always \
  --rm -v "$(realpath $IMAGES_DIR):/data" \
  -w /data \
  quay.io/coreos/coreos-installer:release \
  download -s $STREAM -a $ARCH -p proxmoxve -f qcow2.xz --decompress
