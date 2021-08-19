#!/bin/bash

HOSTNAME=$1

if [[ -z $HOSTNAME ]]; then
    HOSTNAME_LIST=$(linode-cli linodes list --text | awk 'NR>1 {print $2}' ORS=' ')
    echo "Currently running Linodes: $HOSTNAME_LIST"
    read -p "Hostname: " HOSTNAME
fi
read -p "User: " USERNAME

# Get IP
LINODE_IP=$(linode-cli linodes list --text | grep "$HOSTNAME" | awk '{print $7}')

ssh $USERNAME@$LINODE_IP
