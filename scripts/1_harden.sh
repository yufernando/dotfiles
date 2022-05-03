#!/bin/bash
#
# SERVER HARDENING (1_harden.sh)
# Configure SSH, setup ufw firewall and fail2ban
#----------------------------------------------------------------

set -eo pipefail  # option -u throws unbound variable error

echo ""
echo "1. HARDEN: Configure SSH, setup ufw firewall and fail2ban."
echo ""

# Get user input
while [ "$1" != "" ];
do
   case $1 in
   --user )     shift
                USERNAME=$1
                ;;
   --password ) shift
                PASSWORD=$1
                ;;
   --ignoreip ) shift
                IGNOREIP=$1
                ;;
   --sshkey )   shift
                SSHKEY=$1
                ;;
   *)
                echo "Illegal option $1"
                exit 1 # error
                ;;
    esac
    shift
done

echo ""
echo "1. HARDENING: setting up SSH, firewall and fail2ban."
echo ""

apt install -y unattended-upgrades
# dpkg-reconfigure --priority=low unattended-upgrades
adduser $USERNAME --disabled-password --gecos ""
echo "$USERNAME:$PASSWORD" | chpasswd
adduser $USERNAME sudo

# Disable root login and password identification
sed -i -e "s/PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i -e "s/#PermitRootLogin no/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i -e "s/PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
sed -i -e "s/#PasswordAuthentication no/PasswordAuthentication no/" /etc/ssh/sshd_config
echo 'AllowUsers fer' >> /etc/ssh/sshd_config
echo 'AddressFamily inet' >> /etc/ssh/sshd_config

# Setup SSH keys
if [[ -n $SSHKEY ]]; then
    SSHDIR="/home/$USERNAME/.ssh"
    mkdir $SSHDIR && echo "$SSHKEY" >> $SSHDIR/authorized_keys
    chmod -R 700 $SSHDIR && chmod 600 $SSHDIR/authorized_keys
    chown -R $USERNAME:$USERNAME $SSHDIR
fi

if [ ! -f /.docker-date-created ]; then
    systemctl restart sshd

    # Install and configure ufw
    apt install -y ufw
    ufw default allow outgoing
    ufw default deny incoming
    ufw allow ssh
    yes | ufw enable

    # Install and configure Fail2ban
    apt install -y fail2ban
    cd /etc/fail2ban && cp fail2ban.conf fail2ban.local && cp jail.conf jail.local
    if [[ -n $IGNOREIP ]]; then
        echo "ignoreip = $IGNOREIP" >> /etc/fail2ban/jail.local
    fi
    systemctl enable fail2ban
else # Inside Docker container
    service ssh restart
fi
