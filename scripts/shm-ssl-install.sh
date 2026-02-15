#!/bin/bash

# SHM SSL Install Script
# Usage: ./shm-ssl-install.sh example.com

DOMAIN=$1

if [ -z "$DOMAIN" ]; then
    echo "Usage: $0 example.com"
    exit 1
fi

echo "Installing SSL for $DOMAIN via Certbot..."

# Run Certbot (Cloudflare or Nginx plugin)
certbot --nginx --non-interactive --agree-tos --email admin@$DOMAIN -d $DOMAIN -d www.$DOMAIN

if [ $? -eq 0 ]; then
    echo "SSL installed successfully for $DOMAIN."
else
    echo "Error: Certbot failed to install SSL."
    exit 1
fi
