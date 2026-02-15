#!/bin/bash

# SHM WordPress Installer Script
# Usage: ./shm-app-wp.sh example.com

DOMAIN=$1

if [ -z "$DOMAIN" ]; then
    echo "Usage: $0 example.com"
    exit 1
fi

WEB_ROOT="/var/www/clients/$DOMAIN/public_html"
DB_NAME=$(echo "$DOMAIN" | sed 's/\./_/g')
DB_USER="${DB_NAME}_user"
DB_PASS=$(openssl rand -base64 12)

echo "Installing WordPress on $DOMAIN..."

# 1. Create Database
bash /var/www/panel/scripts/shm-db-add.sh "$DB_NAME" "$DB_USER" "$DB_PASS"

# 2. Download WordPress
mkdir -p "$WEB_ROOT"
cd "$WEB_ROOT"
curl -O https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz --strip-components=1
rm latest.tar.gz

# 3. Configure wp-config.php
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/$DB_NAME/" wp-config.php
sed -i "s/username_here/$DB_USER/" wp-config.php
sed -i "s/password_here/$DB_PASS/" wp-config.php

# 4. Set Permissions
chown -R www-data:www-data "$WEB_ROOT"

echo "WordPress installed successfully at $DOMAIN"
echo "Database: $DB_NAME | User: $DB_USER | Pass: $DB_PASS"
echo "Login to complete setup via your browser."
