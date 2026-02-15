# SHM Panel - AI-Driven Server Management

SHM Panel is a professional, production-ready server management solution built for Ubuntu 22.04 LTS. It features **VEDA**, an integrated AI orchestrator that allows you to manage your VPS using natural language commands.

## 🚀 Step-by-Step Deployment Guide

Follow these steps to deploy SHM Panel on a fresh VPS.

### 📋 1. Pre-requisites
- **OS**: Ubuntu 22.04 LTS (Jammy Jellyfish).
- **Resources**: 1GB RAM minimum (2GB+ recommended).
- **Access**: Root or a user with `sudo` privileges.
- **PHP Support**: Compatibility for PHP 8.1, 8.2, and 8.4 is built-in.

### 🛠️ 2. Initialize the Environment
Connect to your VPS via SSH and clone the project:
```bash
sudo mkdir -p /var/www/panel
cd /var/www/panel
# Clone your repository here
git clone <your-repository-url> .
```

### 📦 3. Run the Master Installer
The `setup_vivzon.sh` script automates the installation of the LEMP stack, security layers, and AI core.
```bash
sudo chmod +x setup_vivzon.sh
sudo ./setup_vivzon.sh
```
*Note: This script will automatically stop Apache if it's conflicting with Nginx port 80.*

### 📂 4. Install Dependencies
Install the Laravel framework core and vendor packages:
```bash
export COMPOSER_ALLOW_SUPERUSER=1
composer install
```

### 🗄️ 5. Database Setup
Sync the database structure including the new Authentication, API, and Webhook tables:
```bash
php artisan migrate
```

### 🌍 6. Access & Finalize
1. Open `http://your-server-ip` in your browser.
2. Complete the **First-Run Setup** to create your Admin account.
3. Access the **Marketplace** for one-click app deployments.

---

## 🧠 VEDA AI Commands
VEDA understands English & Hinglish. Manage your server by typing or speaking:
- **Domains**: "add domain example.com"
- **App Deploy**: "install wordpress example.com", "deploy laravel example.com"
- **Security**: "security audit", "port allow 8080", "generate api token"
- **Maintenance**: "system update", "self heal", "optimize server"
- **Backups**: "backup lelo", "cloud backup s3"

## 🛡️ Developer API & Webhooks
- **REST API**: Accessible at `/api/v1/*` using Sanctum tokens.
- **Webhooks**: Real-time notifications for `domain.created`, `ssl.installed`, `database.created`, and `backup.completed`.

---
Created by VEDA AI Agent | SHM Panel Production 1.0
