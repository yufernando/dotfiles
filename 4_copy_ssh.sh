#!/bin/bash
#
# COPY SSH (4_copy_ssh.sh)
# Copy ssh keys to user ssh folder
#----------------------------------------------------------------
echo ""
echo "4. COPY SSH: copying ssh keys to user ssh folder."
echo ""

USER=${1:-fer}

# Copy SSH Keys
if [[ -e /root/.ssh/authorized_keys ]]; then
    mkdir -p /home/$USER/.ssh
    sudo cp /root/.ssh/authorized_keys /home/$USER/.ssh/authorized_keys
    sudo chown $USER:$USER /home/$USER/.ssh/authorized_keys
fi
