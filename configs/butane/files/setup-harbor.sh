#!/bin/bash
set -euo pipefail

HARBOR_VERSION="${HARBOR_VERSION}"
INSTALL_DIR="/var/harbor/install"
WORK_DIR="/var/harbor/work"
CERT_DIR="${WORK_DIR}/certs"

# Skip if already installed
if [[ -f "${INSTALL_DIR}/harbor/docker-compose.yml" ]]; then
    echo "Harbor already installed, skipping download."
    exit 0
fi

# Download Harbor online installer
echo "Downloading Harbor ${HARBOR_VERSION} online installer..."
curl -fsSL "https://github.com/goharbor/harbor/releases/download/${HARBOR_VERSION}/harbor-online-installer-${HARBOR_VERSION}.tgz" \
    -o /tmp/harbor-online-installer.tgz

tar xzf /tmp/harbor-online-installer.tgz -C "${INSTALL_DIR}"
rm -f /tmp/harbor-online-installer.tgz

# Copy our config into place
cp /var/harbor/install/harbor.yml.tmpl "${INSTALL_DIR}/harbor/harbor.yml"

# Run the installer
cd "${INSTALL_DIR}/harbor"
./install.sh

echo "Harbor installation complete."
