# SHM Panel - Complete Deployment Guide

This guide provides a step-by-step walkthrough for deploying the SHM Panel on a fresh Ubuntu VPS using the unified installer.

## 📋 Pre-requisites
- **OS**: Ubuntu 22.04 LTS (Jammy Jellyfish)
- **Resources**: 1GB RAM minimum (2GB+ recommended)
- **Access**: Root/Sudo privileges on a fresh VPS.
- **Domain**: A domain name (e.g., `panel.yourdomain.com`) pointing to your server's IP address.

## 🚀 Step 1: Clone the Repository
Connect to your server via SSH and clone the codebase into the panel directory:

```bash
sudo mkdir -p /var/www/panel
cd /var/www/panel
sudo git clone https://github.com/vivzon/server-panel.git .
```

## 🛠️ Step 2: Run the Master Installer
The `setup_vivzon.sh` script automates the entire installation process, including Nginx, MariaDB, PHP, Composer dependencies, and security configurations.

```bash
sudo chmod +x setup_vivzon.sh
sudo ./setup_vivzon.sh
```

**What the script does:**
- Updates system packages and installs the LEMP stack.
- Installs Composer and runs `composer install`.
- Configures the `.env` file and generates the application key.
- Sets up the database and runs migrations.
- Configures Nginx, Firewall (UFW), and Fail2ban.
- Sets up system cron jobs for scheduling and self-healing.

## 🌍 Step 3: Access the Panel
Once the installer completes, it will display your server's IP address and database credentials.
1. Open your browser and go to: `http://your-server-ip`
2. Log in with the default credentials:
    - **User**: admin
    - **Password**: shm_panel_pass
3. **Change your password immediately** after logging in.

## 🧠 Step 4: Using VEDA AI
After setup, you can manage your server entirely through natural language via the VEDA Console on the dashboard.

## 🛡️ Step 5: Post-Installation Hardening
1. **Change Default DB Passwords**: Update `.env` and MariaDB credentials if you didn't change them during setup.
2. **Setup SSL**: Use VEDA to install SSL for your panel domain: `install ssl`.
3. **Cloud Backups**: Run `rclone config` to link your S3/GDrive, then use VEDA for `cloud backup s3`.
