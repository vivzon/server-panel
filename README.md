# SHM Panel - AI-Driven Server Management

SHM Panel is a professional, production-ready server management solution built for Ubuntu 22.04/24.04. It features **VEDA**, an integrated AI orchestrator that allows you to manage your VPS using natural language commands.

## 🚀 One-Command Installation

To install SHM Panel on a fresh Ubuntu VPS, run the following command as root:

```bash
curl -sSL https://raw.githubusercontent.com/your-repo/server-panel/main/scripts/setup_shm.sh | sudo bash
```

*Note: Replace the URL with your actual repository link or download the script manually.*

### Manual Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/server-panel.git /var/www/panel
   ```
2. Run the master setup script:
   ```bash
   sudo bash /var/www/panel/scripts/setup_shm.sh
   ```

## 🧠 VEDA AI Commands
VEDA understands Hinglish and English. You can interact with it via the integrated terminal in the panel dashboard.

### Examples:
- **Domains**: "add domain example.com", "domain add karo example.com"
- **SSL**: "ssl lagao", "install ssl"
- **Database**: "create database mydb", "database banao shm_db"
- **Mail**: "mail server setup karo", "email banao user@example.com"
- **Security**: "firewall status", "port allow karo 8080", "system audit"
- **Apps**: "wordpress install karo blog.com", "install nodejs example.com myapp"
- **Backups**: "backup lelo", "cloud backup s3"
- **Maintenance**: "self heal", "server status", "logs dikhao nginx"

## 🛡️ Key Features
- **Self-Healing**: Automatic watchdog that monitors and repairs services every 5 minutes.
- **Security Jails**: Fail2ban protection for SSH, Nginx, and Panel logins.
- **Client Isolation**: Multi-client directory structure in `/var/www/clients`.
- **Resource Insights**: Real-time CPU, RAM, and Disk monitoring with per-client reports.
- **Cloud Ready**: Off-site backups integrated with Rclone (S3, GDrive, B2).

## 📂 Project Structure
- `/app`: Laravel backend logic.
- `/resources`: Frontend views and assets.
- `/scripts`: Bash automation layer.
- `/templates`: Standardized Nginx and Bind9 configuration maps.
- `/storage/backups`: Local system backup repository.

## 📄 License
MIT License. Created by VEDA AI Agent.
