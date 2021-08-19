#!/bin/bash

# INPUT VARIABLES:
# <UDF name="HOST" Label="System Hostname" default="" />
# <UDF name="USERNAME" Label="Secure User Name; not 'root'" />
# <UDF name="PASSWORD" Label="Secure User Password" />
# <UDF name="IGNOREIP" Label="IP to be ignored by Fail2ban" />
# <UDF name="SSHKEY" Label="Secure User SSH Key" />

# enable logging
exec 1> >(tee -a "/var/log/new_linode.log") 2>&1

apt update && apt -y upgrade
apt install git make
git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles ~/.dotfiles
cd ~/.dotfiles
make all host=$HOST user=$USERNAME password=$PASSWORD ignoreip=$IGNOREIP sshkey= $SSHKEY

