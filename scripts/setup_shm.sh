#!/bin/bash

# SHM Panel - Master Installer
# Author: VEDA AI Agent
# Targeted OS: Ubuntu 22.04 / 24.04

set -e

echo "------------------------------------------------"
echo "   SHM PANEL MASTER INSTALLER (PRO VERSION)   "
echo "------------------------------------------------"

# Function to wait for apt lock
wait_for_apt() {
    echo "Checking for background package managers..."
    while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 || fuser /var/lib/apt/lists/lock >/dev/null 2>&1 ; do
        echo "Apt is currently locked by another process (likely unattended-upgrades). Waiting 5 seconds..."
        sleep 5
    done
}

# 1. Wait for Locks and Update
wait_for_apt
apt-get update
apt-get install -y software-properties-common
add-apt-repository -y ppa:ondrej/php
apt-get update

apt-get install -y nginx mariadb-server php8.2-fpm php8.2-mysql php8.2-xml php8.2-curl php8.2-mbstring php8.2-zip unzip certbot python3-certbot-nginx bind9 postfix dovecot-imapd dovecot-pop3d fail2ban ufw htop curl git

# 2. Install Composer if missing
if ! command -v composer &> /dev/null; then
    echo "Installing Composer..."
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
fi

# 3. Setup Directory Structure
mkdir -p /var/www/panel
mkdir -p /var/www/clients
mkdir -p /etc/bind/zones

# 4. Laravel App Setup
cd /var/www/panel
if [ -f "composer.json" ]; then
    echo "Running Composer Install..."
    composer install --no-interaction --prefer-dist --optimize-autoloader
    
    if [ ! -f ".env" ]; then
        cp .env.example .env
        php artisan key:generate
    fi
    
    # Setup Database Link (Simplified)
    sed -i "s/DB_DATABASE=laravel/DB_DATABASE=shm_panel/" .env
    sed -i "s/DB_USERNAME=root/DB_USERNAME=admin/" .env
    sed -i "s/DB_PASSWORD=/DB_PASSWORD=shm_panel_pass/" .env
fi

# 3. Create Nginx Default Config for Panel
cat <<EOF > /etc/nginx/sites-available/shm-panel
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    root /var/www/panel/public;
    index index.php index.html;
    server_name _;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/shm-panel /etc/nginx/sites-enabled/
systemctl restart nginx

# 4. Permissions
mkdir -p /var/www/panel/storage /var/www/panel/bootstrap/cache
chown -R www-data:www-data /var/www/panel
chmod -R 755 /var/www/panel/scripts
chmod -R 775 /var/www/panel/storage /var/www/panel/bootstrap/cache

# 4. Configure Firewall (Safe Defaults)
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 53/udp
ufw allow 25/tcp
ufw allow 143/tcp
ufw allow 587/tcp
ufw --force enable

# 5. Database Setup (MariaDB)
mysql -e "CREATE DATABASE IF NOT EXISTS shm_panel;"
mysql -e "CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'shm_panel_pass';"
mysql -e "GRANT ALL PRIVILEGES ON shm_panel.* TO 'admin'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# 6. Cron Jobs
(crontab -l 2>/dev/null; echo "*/5 * * * * /var/www/panel/scripts/shm-self-heal.sh") | crontab -

# 7. Final Polish
echo "Installing Fail2ban Security..."
/var/www/panel/scripts/shm-jail.sh

echo "------------------------------------------------"
echo "   SHM PANEL INSTALLATION COMPLETE!           "
echo "   Access your panel at: http://$(hostname -I | awk '{print $1}')"
echo "------------------------------------------------"
