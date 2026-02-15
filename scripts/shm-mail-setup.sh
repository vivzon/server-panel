#!/bin/bash

# SHM Mail Server Setup Script
# Author: VEDA AI Agent
# Configures Postfix and Dovecot for virtual hosting

echo "Configuring Postfix and Dovecot..."

# 1. Postfix Configuration
postconf -e "virtual_mailbox_domains = /etc/postfix/vhosts"
postconf -e "virtual_mailbox_base = /var/mail/vhosts"
postconf -e "virtual_mailbox_maps = hash:/etc/postfix/vmaps"
postconf -e "virtual_minimum_uid = 1000"
postconf -e "virtual_uid_maps = static:5000"
postconf -e "virtual_gid_maps = static:5000"

# 2. Setup Vmail User
groupadd -g 5000 vmail || true
useradd -g vmail -u 5000 vmail -d /var/mail -m || true

# 3. Create initial config files
touch /etc/postfix/vhosts
touch /etc/postfix/vmaps
postmap /etc/postfix/vmaps

# 4. Dovecot Configuration (Minimal)
cat <<EOF > /etc/dovecot/conf.d/10-mail.conf
mail_location = maildir:/var/mail/vhosts/%d/%n
namespace inbox {
  inbox = yes
}
mail_privileged_group = vmail
EOF

cat <<EOF > /etc/dovecot/conf.d/10-auth.conf
disable_plaintext_auth = no
auth_mechanisms = plain login
!include auth-system.conf.ext
EOF

# 5. Restart services
systemctl restart postfix
systemctl restart dovecot

echo "Mail server base configuration complete."
