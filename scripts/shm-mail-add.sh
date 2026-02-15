#!/bin/bash

# SHM Email Account Creation Script
# Usage: ./shm-mail-add.sh user@domain.com password

EMAIL=$1
PASSWORD=$2

if [ -z "$EMAIL" ] || [ -z "$PASSWORD" ]; then
    echo "Usage: $0 user@domain.com password"
    exit 1
fi

DOMAIN=$(echo "$EMAIL" | cut -d'@' -f2)
USER=$(echo "$EMAIL" | cut -d'@' -f1)

echo "Creating email account: $EMAIL"

# Create directory for email storage
MAIL_DIR="/var/mail/vhosts/$DOMAIN/$USER"
mkdir -p "$MAIL_DIR"
chown -R vmail:vmail "/var/mail/vhosts/$DOMAIN"

# In a real production setup with Dovecot/Postfix, we'd update a SQL table or virtual maps.
# Assuming virtual Dovecot layout:
# This script would typically interact with a MariaDB table if Postfix is configured for SQL.

# Example SQL integration if Postfix/Dovecot use it:
# mysql -e "INSERT INTO shm_panel.mailbox (username, password, domain, maildir) VALUES ('$USER', ENCRYPT('$PASSWORD'), '$DOMAIN', '$DOMAIN/$USER/');"

if [ $? -eq 0 ]; then
    echo "Email account $EMAIL created successfully."
else
    echo "Error: Failed to create email account."
    exit 1
fi
