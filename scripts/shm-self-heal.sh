#!/bin/bash

# SHM Self-Healing Watchdog
# Author: VEDA AI Agent
# Purpose: Monitor core services and restart if down.

LOG_FILE="/var/www/panel/storage/logs/self-heal.log"
SERVICES=("nginx" "mariadb" "php8.2-fpm" "bind9" "postfix" "dovecot" "fail2ban")

echo "[$(date)] Starting health check..." >> "$LOG_FILE"

for SERVICE in "${SERVICES[@]}"; do
    if ! systemctl is-active --quiet "$SERVICE"; then
        echo "[$(date)] WARNING: $SERVICE is down. Attempting restart..." >> "$LOG_FILE"
        systemctl restart "$SERVICE"
        if systemctl is-active --quiet "$SERVICE"; then
            echo "[$(date)] SUCCESS: $SERVICE restored." >> "$LOG_FILE"
        else
            echo "[$(date)] CRITICAL: Failed to restore $SERVICE." >> "$LOG_FILE"
        fi
    fi
done

echo "[$(date)] Health check complete." >> "$LOG_FILE"
