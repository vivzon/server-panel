#!/bin/bash

# SHM Laravel App Deployer
# Author: VEDA AI Agent
# Usage: ./shm-app-laravel.sh domain_name git_url

DOMAIN=$1
GIT_URL=$2

if [ -z "$DOMAIN" ] || [ -z "$GIT_URL" ]; then
    echo "Usage: $0 domain_name git_url"
    exit 1
fi

CLIENT_ROOT="/var/www/clients/$DOMAIN"
APP_ROOT="$CLIENT_ROOT/public_html" # Often redirected to /public for Laravel

echo "Deploying Laravel to $DOMAIN..."

# 1. Clone app
mkdir -p "$CLIENT_ROOT/temp_deploy"
git clone "$GIT_URL" "$CLIENT_ROOT/temp_deploy"
cp -rv "$CLIENT_ROOT/temp_deploy/." "$APP_ROOT/"
rm -rf "$CLIENT_ROOT/temp_deploy"

cd "$APP_ROOT"

# 2. Environment Setup
if [ -f ".env.example" ] && [ ! -f ".env" ]; then
    cp .env.example .env
    # We would normally prompt for DB credentials or inject SHM managed DB
    php artisan key:generate
fi

# 3. Dependencies
composer install --no-interaction --prefer-dist --optimize-autoloader

# 4. Optimization
php artisan optimize

# 5. Permission fix
chown -R www-data:www-data "$APP_ROOT"
chmod -R 775 "$APP_ROOT/storage" "$APP_ROOT/bootstrap/cache"

echo "Laravel application $DOMAIN deployed successfully."
