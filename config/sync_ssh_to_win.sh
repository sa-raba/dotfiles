#!/bin/bash
# config/sync_ssh_to_win.sh
# Sync .ssh directory from WSL to Windows User Profile .ssh

# Get Windows User Profile path via cmd.exe and convert with wslpath
WIN_PATH=$(cmd.exe /c "echo %USERPROFILE%" 2>/dev/null | tr -d '\r')

if [ -z "$WIN_PATH" ]; then
    echo "Error: Could not determine Windows USERPROFILE path."
    exit 1
fi

WIN_SSH_DIR="$(wslpath "$WIN_PATH")/.ssh/"
WSL_SSH_DIR="$HOME/.ssh/" # Trailing slash is important for rsync content sync

if [ ! -d "$WSL_SSH_DIR" ]; then
    echo "Error: WSL .ssh directory ($WSL_SSH_DIR) not found."
    exit 1
fi

echo "--- Mirroring .ssh from WSL ($WSL_SSH_DIR) to Windows ($WIN_SSH_DIR) ---"
echo "Caution: Files in Windows .ssh that are not in WSL will be DELETED."

# Create destination .ssh directory if it doesn't exist
mkdir -p "$WIN_SSH_DIR"

# Use rsync for mirroring
# -a: archive mode (preserves permissions, timestamps, etc. where possible)
# -v: verbose
# --delete: delete extraneous files from destination (mirroring)
rsync -av --delete "$WSL_SSH_DIR" "$WIN_SSH_DIR"

echo "--- Mirror sync completed successfully! ---"
