#!/bin/bash

# SHM Firewall Management Script
# Usage: ./shm-firewall.sh [allow|deny|status] [port]

ACTION=$1
PORT=$2

if [ -z "$ACTION" ]; then
    echo "Usage: $0 [allow|deny|status] [port]"
    exit 1
fi

case "$ACTION" in
    allow)
        if [ -z "$PORT" ]; then echo "Port required for allow."; exit 1; fi
        ufw allow "$PORT"
        echo "Firewall: Allowed port $PORT"
        ;;
    deny)
        if [ -z "$PORT" ]; then echo "Port required for deny."; exit 1; fi
        ufw deny "$PORT"
        echo "Firewall: Denied port $PORT"
        ;;
    status)
        ufw status
        ;;
    *)
        echo "Error: Invalid firewall action."
        exit 1
        ;;
esac
