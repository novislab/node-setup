#!/usr/bin/env bash
set -euo pipefail

# install.sh
# Installs TraffMonetizer, Repocket, and Mysterium (MystNodes).
# WARNING: This script downloads and executes code from third-party sources.
# Review the upstream scripts before running on production systems.

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

install_traffmonetizer() {
    log "Installing TraffMonetizer..."
    curl -fsSL -L https://raw.githubusercontent.com/spiritLHLS/traffmonetizer-one-click-command-installation/main/tm.sh -o tm.sh
    chmod +x tm.sh
    bash tm.sh -t "ITNfBxr7EVpy9841L9gKpuKGd6rD60u7/tjC+yVXo3E="
    log "TraffMonetizer installation completed."
}

install_repocket() {
    log "Installing Repocket..."
    curl -fsSL -L https://raw.githubusercontent.com/spiritLHLS/repocket-one-click-command-installation/main/repocket.sh -o repocket.sh
    chmod +x repocket.sh
    bash repocket.sh -m "novislab.dev@gmail.com" -p "202a5928-a546-40c0-ba84-77f0d8ced9f1"
    log "Repocket installation completed."
}

install_mystnodes() {
    log "Installing MystNodes (Mysterium)..."
    sudo -E bash -c "$(curl -s https://raw.githubusercontent.com/mysteriumnetwork/node/master/install.sh)"
    log "MystNodes installation completed."
}

main() {
    log "Starting node installations..."

    install_traffmonetizer
    install_repocket
    install_mystnodes

    log "All node installations finished successfully."
}

main "$@"
