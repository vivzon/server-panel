#!/bin/bash

# SHM Fail2ban Jail Configuration Script
# Author: VEDA AI Agent
# Purpose: Protect SHM Panel and Nginx from brute force attacks.

echo "Installing and configuring Fail2ban..."

# 1. Install Fail2ban if not present
apt-get update && apt-get install -y fail2ban

# 2. Create Panel Filter
cat <<EOF > /etc/fail2ban/filter.d/shm-panel.conf
[Definition]
failregex = ^.*Authentication failure for .* from <HOST>.*$
ignoreregex =
EOF

# 3. Create Nginx and Panel Jails
cat <<EOF > /etc/fail2ban/jail.local
[DEFAULT]
bantime  = 1h
findtime = 10m
maxretry = 5

[shm-panel]
enabled  = true
port     = http,https
filter   = shm-panel
logpath  = /var/www/panel/storage/logs/laravel.log
maxretry = 5

[nginx-http-auth]
enabled  = true
port     = http,https
logpath  = /var/log/nginx/error.log

[nginx-botsearch]
enabled  = true
port     = http,https
logpath  = /var/log/nginx/access.log
maxretry = 10
EOF

# 4. Restart Fail2ban
systemctl restart fail2ban

# 5. Status logic
if [ "$1" == "status" ]; then
    echo "--- Fail2ban Status ---"
    fail2ban-client status
    echo "--- Active Jails ---"
    fail2ban-client status shm-panel
    fail2ban-client status nginx-http-auth
fi

echo "Fail2ban security jails configured and active."
