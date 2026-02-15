#!/bin/bash

# SHM Cloud Backup Script (Rclone Integration)
# Author: VEDA AI Agent
# Usage: ./shm-backup-cloud.sh remote_name [bucket_path]

REMOTE=$1
PATH_DEST=$2

if [ -z "$REMOTE" ]; then
    echo "Usage: $0 remote_name [bucket_path]"
    echo "Note: Configure rclone first using 'rclone config'"
    exit 1
fi

# 1. Install Rclone if missing
if ! command -v rclone &> /dev/null; then
    echo "Installing Rclone..."
    curl https://rclone.org/install.sh | bash
fi

# 2. Path setup
BACKUP_DIR="/var/www/panel/storage/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="full_backup_$TIMESTAMP.tar.gz"

echo "Creating local backup for upload..."
/var/www/panel/scripts/shm-backup.sh

# 3. Upload to cloud
echo "Uploading $BACKUP_FILE to $REMOTE..."
LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/*.tar.gz | head -1)

if [ -f "$LATEST_BACKUP" ]; then
    rclone copy "$LATEST_BACKUP" "$REMOTE:$PATH_DEST" --progress
    echo "Cloud backup to $REMOTE successful."
else
    echo "Error: Local backup file not found."
    exit 1
fi
