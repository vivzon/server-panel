# SHM Panel - AI-Driven Server Management

SHM Panel is a professional, production-ready server management solution built for Ubuntu 22.04 LTS. It features **VEDA**, an integrated AI orchestrator that allows you to manage your VPS using natural language commands.

## 🚀 Step-by-Step Deployment Guide

Follow these steps to deploy SHM Panel on a fresh VPS.

### 📋 1. Pre-requisites
- **OS**: Ubuntu 22.04 LTS (Jammy Jellyfish).
- **Resources**: 1GB RAM minimum (2GB+ recommended).
- **Access**: Root or a user with `sudo` privileges.

### 🛠️ 2. One-Command Installation
Connect to your VPS via SSH and run the following commands:
```bash
sudo mkdir -p /var/www/panel
cd /var/www/panel
# IMPORTANT: Note the dot "." at the end to clone into current folder
git clone https://github.com/vivzon/server-panel.git .

# Make the installer executable and run it
sudo chmod +x setup_vivzon.sh
sudo ./setup_vivzon.sh
```

**The installer will automatically:**
- Update your system and install PHP 8.2, Nginx, MariaDB, and Mail services.
- install Composer and application dependencies.
- Configure the database and run migrations.
- Set up system security (UFW, Fail2ban) and cron jobs.

### 🌍 3. Access & Finalize
1. Open `http://your-server-ip` in your browser.
2. Login with the default credentials (if not changed during setup):
   - **User**: admin
   - **Password**: shm_panel_pass
3. **Important**: Change your password immediately!

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
