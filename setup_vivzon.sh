#!/bin/bash

# VIVZON SHM PANEL - MASTER INSTALLER
# Target: Ubuntu 22.04 LTS
# Author: VEDA AI Agent .

set -e

echo "------------------------------------------------"
echo "   VIVZON SHM PANEL & VEDA AI INSTALLER"
echo "------------------------------------------------"

# 1. Base Setup
bash scripts/setup.sh

# 1.5 Port Conflict Cleanup (Stop Apache to allow Nginx)
if systemctl is-active --quiet apache2; then
    echo "Stopping Apache to allow Nginx to bind to port 80..."
    systemctl stop apache2
    systemctl disable apache2
fi

# 2. Deploy Laravel Panel
# Handle case where script is run from /var/www/panel itself
if [ "$(pwd)" != "/var/www/panel" ]; then
    mkdir -p /var/www/panel
    cp -r . /var/www/panel/
fi
chown -R www-data:www-data /var/www/panel
chmod -R 775 /var/www/panel/storage /var/www/panel/bootstrap/cache

# 3. Configure Nginx for Panel
PHP_VER=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
FPM_SOCKET="/var/run/php/php${PHP_VER}-fpm.sock"

echo "Detected PHP Version: $PHP_VER"
echo "Targeting FPM Socket: $FPM_SOCKET"

cat <<EOF > /etc/nginx/sites-available/shm-panel
server {
    listen 80;
    server_name _; # Default server
    root /var/www/panel/public;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:$FPM_SOCKET;
    }
}
EOF

ln -sf /etc/nginx/sites-available/shm-panel /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
systemctl reload nginx

# 4. Final Touches
echo "------------------------------------------------"
echo "INSTALLATION COMPLETE!"
echo "Access your panel at: http://$(hostname -I | awk '{print $1}')"
echo "VEDA is now active and listening."
echo "------------------------------------------------"
