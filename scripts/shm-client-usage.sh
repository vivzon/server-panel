#!/bin/bash

# SHM Client Resource Usage Script
# Author: VEDA AI Agent
# Usage: ./shm-client-usage.sh [client_name]

CLIENT=$1

echo "------------------------------------------------"
echo "   SHM PANEL: CLIENT RESOURCE REPORT           "
echo "------------------------------------------------"

if [ ! -z "$CLIENT" ]; then
    # Specific client report
    CLIENT_DIR="/var/www/clients/$CLIENT"
    if [ ! -d "$CLIENT_DIR" ]; then
        echo "Error: Client $CLIENT not found."
        exit 1
    fi
    DISK=$(du -sh "$CLIENT_DIR" | awk '{print $1}')
    FILES=$(find "$CLIENT_DIR" -type f | wc -l)
    QUOTA=$(cat "$CLIENT_DIR/.quota_limit" 2>/dev/null || echo "No Limit")
    
    echo "Client: $CLIENT"
    echo "Disk Used: $DISK"
    echo "Files: $FILES"
    echo "Quota: $QUOTA"
else
    # Global report for all clients
    echo "Summary of all clients in /var/www/clients:"
    printf "%-20s %-10s %-10s %-10s\n" "CLIENT" "DISK" "FILES" "QUOTA"
    for dir in /var/www/clients/*; do
        if [ -d "$dir" ]; then
            name=$(basename "$dir")
            disk=$(du -sh "$dir" | awk '{print $1}')
            files=$(find "$dir" -type f | wc -l)
            quota=$(cat "$dir/.quota_limit" 2>/dev/null || echo "N/A")
            printf "%-20s %-10s %-10s %-10s\n" "$name" "$disk" "$files" "$quota"
        fi
    done
fi
echo "------------------------------------------------"
