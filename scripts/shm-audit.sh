#!/bin/bash

# SHM Security & Health Audit Tool
# Author: VEDA AI Agent

echo "------------------------------------------------"
echo "   SHM PANEL: SYSTEM SECURITY & HEALTH AUDIT   "
echo "------------------------------------------------"

# 1. Check Root Login
echo "[*] Checking SSH Configuration..."
if grep -q "PermitRootLogin yes" /etc/ssh/sshd_config; then
    echo "[!] WARNING: Root login is permitted via SSH."
else
    echo "[+] SUCCESS: Root login is restricted/configured."
fi

# 2. Check UFW Status
echo "[*] Checking Firewall (UFW)..."
if ufw status | grep -q "Status: active"; then
    echo "[+] SUCCESS: Firewall is active."
else
    echo "[!] CRITICAL: Firewall is DISABLED!"
fi

# 3. Check Fail2ban
echo "[*] Checking Fail2ban..."
if systemctl is-active --quiet fail2ban; then
    echo "[+] SUCCESS: Fail2ban is running."
else
    echo "[!] WARNING: Fail2ban is not running."
fi

# 4. Check Disk Usage
echo "[*] Checking Disk Space..."
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 85 ]; then
    echo "[!] WARNING: Disk usage is high: $DISK_USAGE%"
else
    echo "[+] SUCCESS: Disk usage is normal: $DISK_USAGE%"
fi

# 5. Check Service Health
echo "[*] Checking Critical Services..."
SERVICES=("nginx" "mariadb" "php8.2-fpm" "bind9")
for SERVICE in "${SERVICES[@]}"; do
    if systemctl is-active --quiet "$SERVICE"; then
        echo "[+] $SERVICE is running."
    else
        echo "[!] $SERVICE is DOWN!"
    fi
done

# 6. Check for World-Writable Files in /var/www
echo "[*] Scanning for insecure file permissions in /var/www..."
INSECURE=$(find /var/www -type f -perm -0002 | wc -l)
if [ "$INSECURE" -gt 0 ]; then
    echo "[!] WARNING: $INSECURE world-writable files found in /var/www!"
else
    echo "[+] SUCCESS: No world-writable files found in /var/www."
fi

echo "------------------------------------------------"
echo "   AUDIT COMPLETE. RECOMMENDATION: RUN SELF-HEAL IF ERRORS FOUND. "
echo "------------------------------------------------"
