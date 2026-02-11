#!/bin/zsh
set -o pipefail
set -o errexit
set -o nounset

SCRIPT_DIR="${0:A:h}"
BUTANE_CONFIG="$1"
CONFIGS_DIR="${SCRIPT_DIR}/../configs"
BUTANE_CONFIGS_DIR="${CONFIGS_DIR}/butane"
IGNITION_CONFIGS_DIR="${CONFIGS_DIR}/ignition"
KEYS_DIR="$HOME/.ssh"

if [[ ! -d "$IGNITION_CONFIGS_DIR" ]]; then
  mkdir -p "$IGNITION_CONFIGS_DIR"
fi

# compile input butane config to `ignition` directory with
# `.bu` extension replaced with `.ign`
IGNITION_CONFIG="${BUTANE_CONFIG:r}.ign"
IGNITION_CONFIG_PATH="${IGNITION_CONFIGS_DIR}/${IGNITION_CONFIG}"
podman run --interactive --rm --security-opt label=disable \
  --volume ${BUTANE_CONFIGS_DIR}:/butane \
  --volume ${KEYS_DIR}:/keys \
  --workdir /butane quay.io/coreos/butane:release \
  -d /keys \
  --pretty --strict ${BUTANE_CONFIG} >${IGNITION_CONFIG_PATH}
