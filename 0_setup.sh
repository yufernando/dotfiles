#!/bin/bash

# GENERAL CONFIGURATION
#----------------------------------------------------------------
# Get Hostname
HOSTNAME=$1

# Get IP Addresses
IP_ADDRESS=$(ip address show eth0 | grep "inet " | awk '{print $2}' | cut -d '/' -f1)
IPV6_ADDRESS=$(ip address show eth0 | grep -m1 "inet6 " | awk '{print $2}' | cut -d '/' -f1)

# Set Hostname
apt update
apt dist-upgrade -y
hostnamectl set-hostname $HOSTNAME
echo "$IP_ADDRESS	$HOSTNAME" >> /etc/hosts
echo "$IPV6_ADDRESS	$HOSTNAME" >> /etc/hosts

# Set time
timedatectl set-timezone "America/New_York"
