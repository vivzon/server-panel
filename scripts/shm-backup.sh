#!/bin/bash

# SHM Backup Script
# Usage: ./shm-backup.sh

BACKUP_DIR="/var/www/backups"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
mkdir -p "$BACKUP_DIR"

echo "Starting system-wide backup: $DATE"

# 1. Backup Databases
mysqldump --all-databases > "$BACKUP_DIR/full_db_backup_$DATE.sql"

# 2. Backup Configurations
tar -czf "$BACKUP_DIR/config_backup_$DATE.tar.gz" /etc/nginx/sites-available /etc/bind /etc/postfix /etc/dovecot

# 3. Backup User Data (Client Webs) - Optional: only if space permits
# tar -czf "$BACKUP_DIR/clients_backup_$DATE.tar.gz" /var/www/clients

echo "Backup completed: $BACKUP_DIR/full_db_backup_$DATE.sql"
