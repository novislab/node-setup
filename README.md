# node-setup

One-command installer for passive-income network nodes on Debian/Ubuntu.

## Quick install

Run this on a fresh VPS or home server:

```bash
curl -fsSL https://raw.githubusercontent.com/novislab/node-setup/main/install.sh | bash
```

The script downloads and executes the installer. Review the script first if you prefer:

```bash
curl -fsSL https://raw.githubusercontent.com/novislab/node-setup/main/install.sh -o install.sh
chmod +x install.sh
bash install.sh
```

## What gets installed

| Node | Method | Account linking |
|------|--------|-----------------|
| **TraffMonetizer** | Official spiritLHLS one-liner | Token embedded |
| **Repocket** | Official spiritLHLS one-liner | Email + password embedded |
| **MystNodes (Mysterium)** | Official Mysterium install script | Manual via NodeUI port 4449 |

The installer also:

- Updates all system packages first (`apt-get update && apt-get upgrade`).
- Installs **Docker** automatically using the official [get.docker.com](https://get.docker.com) script, because TraffMonetizer and Repocket run as containers.

MystNodes is installed via the official Mysterium script, but **must be finished manually** by visiting the NodeUI at `http://<ip>:4449` to set your password and link/claim the node.

## Credentials

Credentials are stored at the top of `install.sh` as variables. You can override them without editing the file:

```bash
TRAFFMONETIZER_TOKEN=your-token \
REPOCKET_EMAIL=your-email \
REPOCKET_PASSWORD=your-password \
bash install.sh
```

## Requirements

- Debian/Ubuntu-based system
- `curl` and `sudo` access
- Root or passwordless sudo recommended

## Security notice

This script downloads and runs third-party shell scripts from external repositories. Only run it on systems you control, and keep `install.sh` private if it contains your API keys/tokens.

```bash
chmod 600 install.sh
```

## Troubleshooting

Check service status after installation:

```bash
sudo systemctl status mysterium-node
sudo journalctl -u mysterium-node -f
```

## Disclaimer

Use at your own risk. The authors are not responsible for any issues arising from running third-party node software.
