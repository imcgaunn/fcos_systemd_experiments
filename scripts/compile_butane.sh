#!/bin/zsh
set -o pipefail
set -o errexit
set -o nounset

SCRIPT_DIR="${0:A:h}"
BUTANE_CONFIG="$1"
CONFIGS_DIR="$(realpath ${SCRIPT_DIR}/../configs)"
BUTANE_CONFIGS_DIR="${CONFIGS_DIR}/butane"
BUTANE_FILES_DIR="${BUTANE_CONFIGS_DIR}/files"
IGNITION_CONFIGS_DIR="${CONFIGS_DIR}/ignition"
KEYS_DIR="$HOME/.ssh"

if [[ ! -d "$IGNITION_CONFIGS_DIR" ]]; then
  mkdir -p "$IGNITION_CONFIGS_DIR"
fi

# compile input butane config to `ignition` directory with
# `.bu` extension replaced with `.ign`
IGNITION_CONFIG="${BUTANE_CONFIG:r}.ign"
IGNITION_CONFIG_PATH="$(realpath ${IGNITION_CONFIGS_DIR}/${IGNITION_CONFIG})"
podman run --interactive --rm --security-opt label=disable \
  --volume ${BUTANE_CONFIGS_DIR}:/butane \
  --volume ${BUTANE_FILES_DIR}:/files \
  --workdir /butane quay.io/coreos/butane:release \
  -d /files \
  --pretty --strict ${BUTANE_CONFIG} >${IGNITION_CONFIG_PATH}
echo "compiled butane config to: ${IGNITION_CONFIG_PATH}"
