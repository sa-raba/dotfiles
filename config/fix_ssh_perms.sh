#!/bin/bash
# config/fix_ssh_perms.sh
# Fix permissions for .ssh directory and files

SSH_DIR="$HOME/.ssh"

if [ -d "$SSH_DIR" ]; then
    echo "--- Fixing permissions for $SSH_DIR ---"
    
    # Set directory permissions to 700 (drwx------)
    find "$SSH_DIR" -type d -exec chmod 700 {} +
    echo "Set directories to 700"
    
    # Set file permissions to 600 (-rw-------)
    find "$SSH_DIR" -type f -exec chmod 600 {} +
    echo "Set files to 600"
    
    echo "--- Permissions updated successfully! ---"
else
    echo "Error: $SSH_DIR does not exist."
    exit 1
fi
