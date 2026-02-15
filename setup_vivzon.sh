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

# 2. Deploy Laravel Panel
# Assuming the files are already in the current directory
cp -r . /var/www/panel/
chown -R www-data:www-data /var/www/panel
chmod -R 775 /var/www/panel/storage /var/www/panel/bootstrap/cache

# 3. Configure Nginx for Panel
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
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
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
