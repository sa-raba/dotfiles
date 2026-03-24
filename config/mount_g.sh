#!/bin/bash

MOUNT_POINT="/mnt/g"
DRIVE_LETTER="G:"

# Check if already mounted
if mountpoint -q "$MOUNT_POINT"; then
    echo "Google Drive is already mounted at $MOUNT_POINT"
else
    echo "Mounting Google Drive ($DRIVE_LETTER) to $MOUNT_POINT..."
    
    # Create mount point if it doesn't exist
    if [ ! -d "$MOUNT_POINT" ]; then
        sudo mkdir -p "$MOUNT_POINT"
    fi

    # Mount using drvfs with metadata option for better compatibility
    sudo mount -t drvfs "$DRIVE_LETTER" "$MOUNT_POINT" -o metadata

    if [ $? -eq 0 ]; then
        echo "Successfully mounted $DRIVE_LETTER to $MOUNT_POINT"
    else
        echo "Error: Failed to mount. Ensure Google Drive is running on Windows."
    fi
fi
