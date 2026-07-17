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
| **MystNodes (Mysterium)** | Official Mysterium install script | MystNodes API key embedded |

The installer also:

- Updates all system packages first (`apt-get update && apt-get upgrade`).
- Installs **Docker** automatically using the official [get.docker.com](https://get.docker.com) script, because TraffMonetizer and Repocket run as containers.

MystNodes is claimed automatically via the CLI (`myst cli mmn <api-key>`), so you do **not** need to visit `http://<ip>:4449` to link the node.

## Credentials

Credentials are stored at the top of `install.sh` as variables. You can override them without editing the file:

```bash
MYST_API_KEY=your-mystnodes-key \
TRAFFMONETIZER_TOKEN=your-token \
REPOCKET_EMAIL=your-email \
REPOCKET_PASSWORD=your-password \
bash install.sh
```

Get your MystNodes API key from: https://my.mystnodes.com/me

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

If MystNodes was not claimed automatically, claim it manually:

```bash
sudo myst cli mmn <your-mystnodes-api-key>
```

## Disclaimer

Use at your own risk. The authors are not responsible for any issues arising from running third-party node software.
