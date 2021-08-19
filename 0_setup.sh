#!/bin/bash
#
# GENERAL CONFIGURATION (0_setup.sh)
# Update, upgrade, configure hostname, ip and date
#----------------------------------------------------------------
echo ""
echo "SETUP: Update, upgrade, configure hostname, ip and date."
echo ""

# Update system without any interaction
apt update
DEBIAN_FRONTEND=noninteractive \
  apt-get \
  -o Dpkg::Options::=--force-confold \
  -o Dpkg::Options::=--force-confdef \
  -y --allow-downgrades --allow-remove-essential --allow-change-held-packages

# Get Hostname
HOSTNAME=$1

# Get IP Addresses
IP_ADDRESS=$(ip address show eth0 | grep "inet " | awk '{print $2}' | cut -d '/' -f1)
IPV6_ADDRESS=$(ip address show eth0 | grep -m1 "inet6 " | awk '{print $2}' | cut -d '/' -f1)

# Set Hostname
hostnamectl set-hostname $HOSTNAME
echo "$IP_ADDRESS	$HOSTNAME" >> /etc/hosts
echo "$IPV6_ADDRESS	$HOSTNAME" >> /etc/hosts

# Set time
timedatectl set-timezone "America/New_York"
