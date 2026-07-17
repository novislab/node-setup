#!/usr/bin/env bash
set -euo pipefail

# install.sh
# Installs TraffMonetizer, Repocket, and Mysterium (MystNodes).
# WARNING: This script downloads and executes code from third-party sources.
# Review the upstream scripts before running on production systems.

# --- Credentials ---
# Override any of these by exporting them before running the script, e.g.:
#   MYST_API_KEY=your-key bash install.sh
TRAFFMONETIZER_TOKEN="${TRAFFMONETIZER_TOKEN:-ITNfBxr7EVpy9841L9gKpuKGd6rD60u7/tjC+yVXo3E=}"
REPOCKET_EMAIL="${REPOCKET_EMAIL:-novislab.dev@gmail.com}"
REPOCKET_PASSWORD="${REPOCKET_PASSWORD:-202a5928-a546-40c0-ba84-77f0d8ced9f1}"
MYST_API_KEY="${MYST_API_KEY:-TeIPur9hACxjtycZSODZyDm9WfB6GWXatyw7rURQ}"

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

wait_for_myst() {
    log "Waiting for Mysterium node service to be ready..."
    local attempts=0
    local max_attempts=30
    until curl -fsSL -u myst:mystberry http://127.0.0.1:4050/healthcheck >/dev/null 2>&1; do
        attempts=$((attempts + 1))
        if [[ $attempts -ge $max_attempts ]]; then
            log "WARNING: Mysterium node did not become ready in time."
            return 1
        fi
        sleep 2
    done
    log "Mysterium node service is ready."
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

    log "Starting and enabling Mysterium node service..."
    sudo systemctl enable --now mysterium-node.service || true

    if wait_for_myst; then
        if [[ -n "$MYST_API_KEY" ]]; then
            log "Claiming MystNodes node with provided API key..."
            if sudo myst cli --agreed-terms-and-conditions mmn "$MYST_API_KEY"; then
                log "MystNodes node claimed successfully."
            else
                log "WARNING: Failed to claim MystNodes node automatically."
                log "You can claim it manually by running: sudo myst cli mmn <your-api-key>"
            fi
        else
            log "No MYST_API_KEY provided. Skipping automatic node claim."
            log "Get your API key from https://my.mystnodes.com/me and run: sudo myst cli mmn <your-api-key>"
        fi
    else
        log "WARNING: Could not confirm Mysterium node readiness. Skipping automatic claim."
    fi

    log "MystNodes installation completed."
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
