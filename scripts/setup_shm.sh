#!/bin/bash

# SHM Panel - Master Installer
# Author: VEDA AI Agent
# Targeted OS: Ubuntu 22.04 / 24.04

set -e

echo "------------------------------------------------"
echo "   SHM PANEL MASTER INSTALLER (PRO VERSION)   "
echo "------------------------------------------------"

# 1. Update and Install Core Dependencies
apt-get update
apt-get install -y nginx mariadb-server php8.2-fpm php8.2-mysql php8.2-xml php8.2-curl php8.2-mbstring php8.2-zip unzip certbot python3-certbot-nginx bind9 postfix dovecot-imapd dovecot-pop3d fail2ban ufw htop curl

# 2. Setup Directory Structure
mkdir -p /var/www/panel
mkdir -p /var/www/clients
mkdir -p /etc/bind/zones

# 3. Permissions
chown -R www-data:www-data /var/www/panel
chmod -R 755 /var/www/panel/scripts

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
