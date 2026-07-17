#!/usr/bin/env bash
set -euo pipefail

# install.sh
# Installs TraffMonetizer, Repocket, and Mysterium (MystNodes).
# WARNING: This script downloads and executes code from third-party sources.
# Review the upstream scripts before running on production systems.

# --- Credentials ---
# Override any of these by exporting them before running the script, e.g.:
#   TRAFFMONETIZER_TOKEN=your-token bash install.sh
TRAFFMONETIZER_TOKEN="${TRAFFMONETIZER_TOKEN:-ITNfBxr7EVpy9841L9gKpuKGd6rD60u7/tjC+yVXo3E=}"
REPOCKET_EMAIL="${REPOCKET_EMAIL:-novislab.dev@gmail.com}"
REPOCKET_PASSWORD="${REPOCKET_PASSWORD:-202a5928-a546-40c0-ba84-77f0d8ced9f1}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

prepare_system() {
    log "Updating system packages..."
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get update
    sudo apt-get upgrade -y -o Dpkg::Options::="--force-confold"

    log "Installing required base packages..."
    sudo apt-get install -y curl ca-certificates gnupg lsb-release software-properties-common apt-transport-https
}

install_docker() {
    if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
        log "Docker is already installed and running."
        return 0
    fi

    log "Installing Docker via official Docker install script..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm -f get-docker.sh

    log "Starting and enabling Docker service..."
    sudo systemctl enable --now docker

    log "Adding current user to docker group (logout/login may be required)..."
    sudo usermod -aG docker "${USER}" || true

    # Verify Docker is usable
    if ! sudo docker info >/dev/null 2>&1; then
        log "WARNING: Docker installation completed but docker info is not responding yet."
    fi
}

install_traffmonetizer() {
    log "Installing TraffMonetizer..."
    curl -fsSL -L https://raw.githubusercontent.com/spiritLHLS/traffmonetizer-one-click-command-installation/main/tm.sh -o tm.sh
    chmod +x tm.sh
    sudo bash tm.sh -t "$TRAFFMONETIZER_TOKEN"
    log "TraffMonetizer installation completed."
}

install_repocket() {
    log "Installing Repocket..."
    curl -fsSL -L https://raw.githubusercontent.com/spiritLHLS/repocket-one-click-command-installation/main/repocket.sh -o repocket.sh
    chmod +x repocket.sh
    sudo bash repocket.sh -m "$REPOCKET_EMAIL" -p "$REPOCKET_PASSWORD"
    log "Repocket installation completed."
}

install_mystnodes() {
    log "Installing MystNodes (Mysterium)..."
    sudo -E bash -c "$(curl -s https://raw.githubusercontent.com/mysteriumnetwork/node/master/install.sh)"
    log "MystNodes installation completed. Open http://$(hostname -I | awk '{print $1}' | xargs):4449 to finish setup manually."
}

main() {
    log "Starting node installations..."

    prepare_system
    install_docker
    install_traffmonetizer
    install_repocket
    install_mystnodes

    log "All node installations finished successfully."
}

main "$@"
