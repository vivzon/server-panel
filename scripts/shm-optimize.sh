#!/bin/bash

# SHM Performance Optimizer
# Author: VEDA AI Agent
# Purpose: Tune Nginx and MariaDB based on available system RAM.

echo "------------------------------------------------"
echo "   SHM PERFORMANCE OPTIMIZER (v1.0)   "
echo "------------------------------------------------"

# Get total RAM in MB
TOTAL_RAM=$(free -m | awk '/^Mem:/{print $2}')
echo "Detected Total RAM: ${TOTAL_RAM}MB"

# 1. Nginx Optimization
# Adjust worker connections based on RAM
if [ "$TOTAL_RAM" -lt 1024 ]; then
    WORKER_CONNECTIONS=768
elif [ "$TOTAL_RAM" -lt 4096 ]; then
    WORKER_CONNECTIONS=1024
else
    WORKER_CONNECTIONS=2048
fi

echo "Optimizing Nginx..."
sed -i "s/worker_connections .*/worker_connections $WORKER_CONNECTIONS;/" /etc/nginx/nginx.conf

# 2. MariaDB Optimization
# Set InnoDB buffer pool size to ~50-60% of total RAM if dedicated, 
# but for a web panel we'll stay safer around 30-40%.
BUFFER_POOL_SIZE=$((TOTAL_RAM * 40 / 100))
echo "Optimizing MariaDB (InnoDB Buffer Pool: ${BUFFER_POOL_SIZE}M)..."

MY_CNF="/etc/mysql/mariadb.conf.d/50-server.cnf"
if [ -f "$MY_CNF" ]; then
    # Ensure innodb_buffer_pool_size exists or append it
    if grep -q "innodb_buffer_pool_size" "$MY_CNF"; then
        sed -i "s/innodb_buffer_pool_size .*/innodb_buffer_pool_size = ${BUFFER_POOL_SIZE}M/" "$MY_CNF"
    else
        sed -i "/\[mysqld\]/a innodb_buffer_pool_size = ${BUFFER_POOL_SIZE}M" "$MY_CNF"
    fi
fi

# 3. Apply Changes
echo "Restarting services..."
systemctl restart nginx
systemctl restart mariadb

echo "------------------------------------------------"
echo "   OPTIMIZATION COMPLETE!   "
echo "------------------------------------------------"
