#!/bin/bash
#
# COPY SSH (4_copy_ssh.sh)
# Copy ssh keys to user ssh folder
#----------------------------------------------------------------

set -eo pipefail  # option -u throws unbound variable error

echo ""
echo "4. COPY SSH: copying ssh keys to user ssh folder."
echo ""

USER=$1
SSHKEY=$2

# If SSHKEY is not set, this script is not part of an automated pipeline. The
# Linux VM was configured manually so there are SSH keys in root. Copy them to
# the user folder:
if [[ -z $SSHKEY ]]; then
    echo "No SSHKEY input."
    if [[ -e /root/.ssh/authorized_keys ]]; then
        echo "Found SSHKEY for root. Copying SSHKEY from root to user."
        mkdir -p /home/$USER/.ssh
        cp /root/.ssh/authorized_keys /home/$USER/.ssh/authorized_keys
        chown $USER:$USER /home/$USER/.ssh/authorized_keys
    fi
fi
