#!/bin/bash

# SHM Stats Extraction Script
# Author: VEDA AI Agent

# CPU Usage
CPU=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

# Memory Usage (MB)
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_PERC=$(awk "BEGIN {print ($MEM_USED/$MEM_TOTAL)*100}")

# Disk Usage
DISK_PERC=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

# Uptime
UPTIME=$(uptime -p)

# Output as JSON
echo "{\"cpu\": $CPU, \"mem\": $MEM_PERC, \"mem_used\": $MEM_USED, \"mem_total\": $MEM_TOTAL, \"disk\": $DISK_PERC, \"uptime\": \"$UPTIME\"}"
