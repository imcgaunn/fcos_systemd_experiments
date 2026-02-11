STREAM="stable"
# as an installed binary:
#coreos-installer download -s $STREAM -p proxmoxve -f qcow2.xz --decompress -C /var/coreos
# or as a container:
podman run --pull=always \
  --rm -v "./images:/data" \
  -w /data \
  quay.io/coreos/coreos-installer:release \
  download -s $STREAM -p proxmoxve -f qcow2.xz --decompress
