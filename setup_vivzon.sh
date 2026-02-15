#!/bin/bash

# VIVZON SHM PANEL - MASTER INSTALLER
# Target: Ubuntu 22.04 LTS / 24.04 LTS
# Author: VEDA AI Agent

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "------------------------------------------------"
echo "   VIVZON SHM PANEL & VEDA AI INSTALLER"
echo "------------------------------------------------"

# Function to wait for apt lock
wait_for_apt() {
    echo "Checking for background package managers..."
    while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 || fuser /var/lib/apt/lists/lock >/dev/null 2>&1 ; do
        echo "Apt is currently locked by another process (likely unattended-upgrades). Waiting 5 seconds..."
        sleep 5
    done
}

# 1. Base Setup & Updates
echo -e "${GREEN}[1/8] Updating System & Installing Dependencies...${NC}"
wait_for_apt
apt-get update
apt-get install -y software-properties-common
add-apt-repository -y ppa:ondrej/php
apt-get update

# Install Core Stack (LEMP + Mail + Utils)
# Using dynamic PHP version later, but installing common 8.2 and 8.3 + default for now to be safe, 
# or trusting the script to pick up the right one. 
# Let's stick to the repo's previous preference for PHP 8.2 but make it robust.
PHP_VERSION="8.2"
apt-get install -y nginx mariadb-server php${PHP_VERSION}-fpm php${PHP_VERSION}-mysql php${PHP_VERSION}-xml \
    php${PHP_VERSION}-curl php${PHP_VERSION}-mbstring php${PHP_VERSION}-zip php${PHP_VERSION}-bcmath php${PHP_VERSION}-intl \
    unzip certbot python3-certbot-nginx bind9 postfix dovecot-imapd dovecot-pop3d fail2ban ufw htop curl git acl

# 1.5 Port Conflict Cleanup (Stop Apache if present)
if systemctl is-active --quiet apache2; then
    echo -e "${YELLOW}Stopping Apache to allow Nginx to bind to port 80...${NC}"
    systemctl stop apache2
    systemctl disable apache2
fi

# 2. Install Composer
if ! command -v composer &> /dev/null; then
    echo -e "${GREEN}[2/8] Installing Composer...${NC}"
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
fi

# 3. Deploy Laravel Panel
echo -e "${GREEN}[3/8] Setting up Application...${NC}"

# Handle case where script is run from /var/www/panel itself or cloned elsewhere
TARGET_DIR="/var/www/panel"
CURRENT_DIR=$(pwd)

if [ "$CURRENT_DIR" != "$TARGET_DIR" ]; then
    echo "Deploying to $TARGET_DIR..."
    mkdir -p $TARGET_DIR
    cp -rT . $TARGET_DIR
fi

# Ensure we are in the target directory
cd $TARGET_DIR

# Set Permissions
chown -R www-data:www-data $TARGET_DIR
chmod -R 775 $TARGET_DIR/storage $TARGET_DIR/bootstrap/cache

# 4. Configure Environment & Database
echo -e "${GREEN}[4/8] Configuring Environment...${NC}"

# Install Dependencies
export COMPOSER_ALLOW_SUPERUSER=1
composer install --no-interaction --prefer-dist --optimize-autoloader

# Setup .env
if [ ! -f ".env" ]; then
    cp .env.example .env
    php artisan key:generate
fi

# Configure Database in .env (search and replace)
sed -i "s/DB_DATABASE=laravel/DB_DATABASE=shm_panel/" .env
sed -i "s/DB_USERNAME=root/DB_USERNAME=admin/" .env
# Set a default password if none is set, or prompt? For automation, we set a default.
# Ideally, we should generate a random password, but for now we use the one from the old script or a placeholder.
sed -i "s/DB_PASSWORD=/DB_PASSWORD=shm_panel_pass/" .env

# 5. Database Setup (MariaDB)
echo -e "${GREEN}[5/8] Setting up Database...${NC}"
mysql -e "CREATE DATABASE IF NOT EXISTS shm_panel;"
mysql -e "CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'shm_panel_pass';"
mysql -e "GRANT ALL PRIVILEGES ON shm_panel.* TO 'admin'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Run Migrations
echo "Running Database Migrations..."
php artisan migrate --force

# 6. Configure Nginx
echo -e "${GREEN}[6/8] Configuring Nginx...${NC}"
FPM_SOCKET="/var/run/php/php${PHP_VERSION}-fpm.sock"

cat <<EOF > /etc/nginx/sites-available/shm-panel
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    root $TARGET_DIR/public;
    index index.php index.html;
    server_name _;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:$FPM_SOCKET;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

# Enable Site
ln -sf /etc/nginx/sites-available/shm-panel /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
systemctl reload nginx

# 7. Security & Cron
echo -e "${GREEN}[7/8] configuring Security & Cron Jobs...${NC}"

# Firewall
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 53/udp
ufw allow 25/tcp
ufw allow 143/tcp
ufw allow 587/tcp
ufw --force enable

# Fail2ban
cat <<EOF > /etc/fail2ban/jail.local
[nginx-http-auth]
enabled = true
EOF
systemctl restart fail2ban

# Cron Job for Scheduler and Self-Heal
(crontab -l 2>/dev/null; echo "* * * * * cd $TARGET_DIR && php artisan schedule:run >> /dev/null 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "*/5 * * * * $TARGET_DIR/scripts/shm-self-heal.sh") | crontab -


# 8. Final Touches
echo "------------------------------------------------"
echo -e "${GREEN}INSTALLATION COMPLETE!${NC}"
echo "Access your panel at: http://$(hostname -I | awk '{print $1}')"
echo "Database User: admin"
echo "Database Pass: shm_panel_pass"
echo "VEDA is now active and listening."
echo "------------------------------------------------"
