#!/bin/bash

# SHM Quota Management Script
# Usage: ./shm-quota.sh set client_name 5G
# Usage: ./shm-quota.sh status client_name

ACTION=$1
CLIENT=$2
LIMIT=$3

CLIENT_ROOT="/var/www/clients/$CLIENT"

if [ ! -d "$CLIENT_ROOT" ]; then
    echo "Client directory not found: $CLIENT_ROOT"
    exit 1
fi

case $ACTION in
    "set")
        if [ -z "$LIMIT" ]; then
            echo "Usage: $0 set client_name limit(e.g. 5G)"
            exit 1
        fi
        echo "Setting quota for $CLIENT to $LIMIT..."
        # In a real Ubuntu environment, this would involve setquota or edquota
        # For this panel, we store it in a metadata file if quotas are not enabled on the FS
        echo "$LIMIT" > "$CLIENT_ROOT/.quota_limit"
        echo "Quota limit of $LIMIT recorded for $CLIENT."
        ;;
    "status")
        CURRENT_SIZE=$(du -sh "$CLIENT_ROOT" | awk '{print $1}')
        LIMIT_VAL=$(cat "$CLIENT_ROOT/.quota_limit" 2>/dev/null || echo "No limit")
        echo "{\"client\": \"$CLIENT\", \"used\": \"$CURRENT_SIZE\", \"limit\": \"$LIMIT_VAL\"}"
        ;;
    *)
        echo "Usage: $0 [set|status] client_name [limit]"
        exit 1
        ;;
esac
