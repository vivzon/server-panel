#!/bin/bash

# SHM Node.js App Installer
# Author: VEDA AI Agent
# Usage: ./shm-app-nodejs.sh domain_name app_name git_url

DOMAIN=$1
APP_NAME=$2
GIT_URL=$3

if [ -z "$DOMAIN" ] || [ -z "$APP_NAME" ]; then
    echo "Usage: $0 domain_name app_name [git_url]"
    exit 1
fi

WEB_ROOT="/var/www/clients/$DOMAIN/apps/$APP_NAME"
mkdir -p "$WEB_ROOT"

# 1. Install Node.js if missing (LTS)
if ! command -v node &> /dev/null; then
    echo "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
    apt-get install -y nodejs
fi

# 2. Install PM2 globally
if ! command -v pm2 &> /dev/null; then
    echo "Installing PM2..."
    npm install -g pm2
fi

# 3. Clone Repository or create dummy
if [ ! -z "$GIT_URL" ]; then
    echo "Cloning $GIT_URL..."
    git clone "$GIT_URL" "$WEB_ROOT"
else
    echo "Creating dummy Node.js app..."
    cat <<EOF > "$WEB_ROOT/index.js"
const http = require('http');
const port = process.env.PORT || 3000;
const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('SHM Panel: Node.js App Running - $APP_NAME\n');
});
server.listen(port, () => {
  console.log(\`Server running at port \${port}\`);
});
EOF
fi

# 4. Install dependencies
cd "$WEB_ROOT"
[ -f "package.json" ] && npm install

# 5. Start with PM2
pm2 start index.js --name "$APP_NAME" --update-env || pm2 start app.js --name "$APP_NAME" || pm2 start server.js --name "$APP_NAME"
pm2 save

# 6. Proxy Nginx (Simplified assumption: proxying to 3000 or custom port)
# In production, we'd update the Nginx vhost template or add a proxy include.
echo "Node.js app $APP_NAME deployed at $WEB_ROOT. Port 3000 (default)."
