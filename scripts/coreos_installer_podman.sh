podman run --pull=always \
  --rm -v "./images:/data" \
  -w /data \
  quay.io/coreos/coreos-installer:release
