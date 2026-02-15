#!/bin/bash

# SHM Database Creation Script
# Usage: ./shm-db-add.sh dbname dbuser dbpass

DB_NAME=$1
DB_USER=$2
DB_PASS=$3

if [ -z "$DB_NAME" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASS" ]; then
    echo "Usage: $0 dbname dbuser dbpass"
    exit 1
fi

echo "Creating database: $DB_NAME for user: $DB_USER"

# Create Database and User
mysql -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"
mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
mysql -e "GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

if [ $? -eq 0 ]; then
    echo "Database $DB_NAME and User $DB_USER created successfully."
else
    echo "Error: Failed to create database."
    exit 1
fi
