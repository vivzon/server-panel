# SHM Panel - Complete Deployment Guide

This guide provides a step-by-step walkthrough for deploying the SHM Panel on a fresh Ubuntu VPS.

## 📋 Pre-requisites
- A fresh VPS running- **OS**: Ubuntu 22.04 LTS (Jammy Jellyfish)
- **PHP**: 8.1 - 8.4 (Nginx/PHP-FPM)
- **Database**: MariaDB 10.6+
- **Access**: Root/Sudo privileges on a fresh VPS.
- **Bootstrapping**: The project now includes a pre-built `artisan` script and core `config/` files for instant deployment.
- A domain name (e.g., `panel.yourdomain.com`) pointing to your server's IP address.
- At least 1GB RAM (2GB+ recommended for mail and multiple apps).

## 🚀 Step 1: Clone the Repository
Connect to your server via SSH and clone the codebase into the panel directory:

```bash
sudo mkdir -p /var/www/panel
sudo git clone https://github.com/vivzon/server-panel.git /var/www/panel
cd /var/www/panel
```

## 🛠️ Step 2: Run the Master Installer
The `setup_shm.sh` script automates the installation of Nginx, MariaDB, PHP 8.2, Bind9, Postfix, Dovecot, Fail2ban, and more.

```bash
sudo bash /var/www/panel/scripts/setup_shm.sh
```

**What the script does:**
- Updates system packages.
- Installs the full LEMP stack + DNS and Mail servers.
- Configures a secure firewall (UFW).
- Sets up a self-healing service watchdog.
- Configures security jails (Fail2ban).

## 🌍 Step 3: Access the Panel
Once the installer completes, it will display your server's IP address.
1. Open your browser and go to: `http://your-server-ip`
2. Follow the **First-Run Setup Wizard** to:
   - Configure the server hostname.
   - Create your Admin Account.
   - Set up the initial system configuration.

## 🧠 Step 4: Using VEDA AI
After setup, you can manage your server entirely through natural language.
- Open the **VEDA Console** on the dashboard.
- Try commands like:
  - `domain add karo example.com`
  - `wordpress install karo example.com`
  - `mail server setup karo`
  - `system health`

## 🛡️ Step 5: Post-Installation Hardening
1. **Change Default DB Passwords**: Update `.env` and MariaDB credentials.
2. **Setup SSL**: Use VEDA to install SSL for your panel domain: `install ssl`.
3. **Cloud Backups**: Run `rclone config` to link your S3/GDrive, then use VEDA for `cloud backup s3`.

## 🆘 Troubleshooting
- **Apt Lock Error**: If you see "Could not get lock", wait 60 seconds for background updates to finish and rerun Step 2.
- **Service Status**: Use `system health` in VEDA to check if any service is down. VEDA will attempt to auto-fix via the `shm-self-heal.sh` watchdog.

---
Created by VEDA AI Agent | SHM Panel Version 1.0
