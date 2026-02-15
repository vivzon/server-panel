#!/bin/bash

# SHM Client Addition Script
# Usage: ./shm-client-add.sh clientname

CLIENT=$1

if [ -z "$CLIENT" ]; then
    echo "Usage: $0 clientname"
    exit 1
fi

echo "Creating infrastructure for client: $CLIENT"

# 1. Create client root
CLIENT_ROOT="/var/www/clients/$CLIENT"
mkdir -p "$CLIENT_ROOT"/{public_html,logs,tmp}

# 2. Set permissions
chown -R www-data:www-data "$CLIENT_ROOT"
chmod -R 755 "$CLIENT_ROOT"

# 3. Create placeholder index
echo "<h1>Welcome to $CLIENT Hosting</h1>" > "$CLIENT_ROOT/public_html/index.html"

echo "Client $CLIENT created at $CLIENT_ROOT"
