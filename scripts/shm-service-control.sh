#!/bin/bash

# SHM Service Control Script
# Usage: ./shm-service-control.sh restart nginx

ACTION=$1
SERVICE=$2

if [ -z "$ACTION" ] || [ -z "$SERVICE" ]; then
    echo "Usage: $0 [restart|start|stop] [nginx|mariadb|php8.2-fpm]"
    exit 1
fi

# Whitelist allowed services
case "$SERVICE" in
    nginx|mariadb|php8.2-fpm|bind9|postfix|dovecot)
        systemctl "$ACTION" "$SERVICE"
        echo "Service $SERVICE $ACTION successful."
        ;;
    *)
        echo "Error: Service $SERVICE is not in the whitelist."
        exit 1
        ;;
esac
