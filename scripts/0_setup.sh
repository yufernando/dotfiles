#!/bin/bash
#
# GENERAL CONFIGURATION (0_setup.sh)
# Update, upgrade, configure hostname, ip and date
#----------------------------------------------------------------
echo ""
echo "SETUP: Update, upgrade, configure hostname, ip and date."
echo ""

set -euo pipefail

# Update system without any interaction
DEBIAN_FRONTEND=noninteractive apt-get --yes update
DEBIAN_FRONTEND=noninteractive \
  apt-get \
  --yes --allow-downgrades --allow-remove-essential --allow-change-held-packages \
  -o Dpkg::Options::=--force-confold \
  -o Dpkg::Options::=--force-confdef \
  dist-upgrade

# Get Hostname
SET_HOSTNAME=$1

# Set Hostname and time
if [ ! -f /.docker-date-created ]; then
    # Get IP Addresses
    IP_ADDRESS=$(ip address show eth0 | grep "inet " | awk '{print $2}' | cut -d '/' -f1)
    IPV6_ADDRESS=$(ip address show eth0 | grep -m1 "inet6 " | awk '{print $2}' | cut -d '/' -f1)
    echo "$IP_ADDRESS	$SET_HOSTNAME" >> /etc/hosts
    echo "$IPV6_ADDRESS	$SET_HOSTNAME" >> /etc/hosts
    # Set hostname
    hostnamectl set-hostname $SET_HOSTNAME
    # Set timezone
    timedatectl set-timezone "America/New_York"
else # Inside Docker container
    echo $SET_HOSTNAME > /etc/hostname
fi
