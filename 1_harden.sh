#!/bin/bash

# SERVER HARDENING
#----------------------------------------------------------------
apt install -y unattended-upgrades
dpkg-reconfigure --priority=low unattended-upgrades
adduser fer
adduser fer sudo

# Disable root login and password identification
sed -i -e "s/PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i -e "s/#PermitRootLogin no/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i -e "s/PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
sed -i -e "s/#PasswordAuthentication no/PasswordAuthentication no/" /etc/ssh/sshd_config
echo 'AllowUsers fer' >> /etc/ssh/sshd_config
echo 'AddressFamily inet' >> /etc/ssh/sshd_config
systemctl restart sshd

# Install and configure ufw
apt install -y ufw
ufw default allow outgoing
ufw default deny incoming
ufw allow ssh
ufw enable

# Install and configure Fail2ban
apt install -y fail2ban
cd /etc/fail2ban && cp fail2ban.conf fail2ban.local && cp jail.conf jail.local
echo 'ignoreip = 66.31.40.222' >> /etc/fail2ban/jail.local
systemctl enable fail2ban

