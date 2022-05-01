#!/bin/bash
# SSH into a Linode
#
# Usage:
#   ./ssh_into_linode.sh [-l]

# Option to show logs
while getopts "l" option; do
    case $option in 
        s) SHOW_LOGS=true ;;
    esac
done
shift $((OPTIND -1))

HOSTNAME=$1

# Get Hostname from user Input
if [[ -z $HOSTNAME ]]; then
    HOSTNAME_LIST=$(linode-cli linodes list --text | awk 'NR>1 {print $2}' ORS=' ')
    echo "Currently running Linodes: $HOSTNAME_LIST"
    read -p "Hostname: " HOSTNAME
fi

# Get IP for that hostname
LINODE_IP=$(linode-cli linodes list --text | grep "$HOSTNAME" | awk '{print $7}')

if [[ -n $SHOW_LOGS ]]; then
    # SSH and get logs
    ssh root$LINODE_IP "tail -f /var/log/new_linode.log"
else
    # SSH with user
    read -p "User: " USERNAME
    ssh $USERNAME@$LINODE_IP
fi
