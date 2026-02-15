#!/bin/bash

# SHM Domain Add Script
# Usage: ./shm-domain-add.sh example.com

DOMAIN=$1

if [ -z "$DOMAIN" ]; then
    echo "Usage: $0 example.com"
    exit 1
fi

echo "Adding domain: $DOMAIN"

# Create web root
WEB_ROOT="/var/www/clients/$DOMAIN"
mkdir -p "$WEB_ROOT"/{public_html,logs}
chown -R www-data:www-data "$WEB_ROOT"

# 2. Create Nginx Configuration from template
NGINX_CONF="/etc/nginx/sites-available/$DOMAIN"
IP_ADDR=$(hostname -I | awk '{print $1}')
sed -e "s|{{DOMAIN}}|$DOMAIN|g" -e "s|{{WEB_ROOT}}|$WEB_ROOT|g" /var/www/panel/templates/nginx-vhost.conf > "$NGINX_CONF"
ln -s "$NGINX_CONF" "/etc/nginx/sites-enabled/"

# 3. Create Bind9 Zone from template
BIND_ZONE="/etc/bind/zones/db.$DOMAIN"
mkdir -p /etc/bind/zones
sed -e "s|{{DOMAIN}}|$DOMAIN|g" -e "s|{{IP}}|$IP_ADDR|g" /var/www/panel/templates/bind9-zone.db > "$BIND_ZONE"
echo "zone \"$DOMAIN\" { type master; file \"$BIND_ZONE\"; };" >> /etc/bind/named.conf.local

# 4. Restart Services
systemctl restart nginx
systemctl reload bind9

echo "Domain $DOMAIN successfully added with templates."
