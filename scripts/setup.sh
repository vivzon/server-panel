#!/bin/bash

# SHM Panel Installer for Ubuntu 22.04
# Author: SHM Team / VEDA AI

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Starting SHM Panel Installation...${NC}"

# Check root
if [ "$EUID" -ne 0 ]; then 
  echo -e "${RED}Please run as root${NC}"
  exit 1
fi

# Update system
apt update && apt upgrade -y

# Install dependencies
apt install -y nginx mariadb-server php8.2-fpm php8.2-mysql php8.2-cli php8.2-curl php8.2-gd php8.2-mbstring php8.2-xml php8.2-zip bind9 postfix dovecot-imapd dovecot-pop3d certbot python3-certbot-nginx roundcube unzip curl git fail2ban ufw

# Create directory structure
mkdir -p /var/www/panel
mkdir -p /var/www/apps
mkdir -p /var/www/clients

# Setup Database
mysql -e "CREATE DATABASE IF NOT EXISTS shm_panel;"
mysql -e "CREATE USER IF NOT EXISTS 'shm_user'@'localhost' IDENTIFIED BY 'shm_password_change_me';"
mysql -e "GRANT ALL PRIVILEGES ON shm_panel.* TO 'shm_user'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Setup Fail2ban
cat <<EOF > /etc/fail2ban/jail.local
[nginx-http-auth]
enabled = true
EOF
systemctl restart fail2ban

# Setup Firewall
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 53/tcp
ufw allow 25/tcp
ufw allow 587/tcp
ufw allow 993/tcp
ufw --force enable

echo -e "${GREEN}SHM Panel Base Setup Complete.${NC}"
echo -e "Next: Deploy Laravel application to /var/www/panel"
