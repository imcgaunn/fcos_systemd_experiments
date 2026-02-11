# fcos_systemd_experiments

this is a repo to experiment with running
systemd-based services with podman and fedora
core os.

## questions

1. how do I package full filesystems / large images
with the iso? I don't want to have to download a bunch of packages with cloud-init at startup when I know before the system ever boots what it should have on it.

- can create qcow2 filesystems and mount them in
- can package resources into an OCI container image and pull them
  on-demand.
