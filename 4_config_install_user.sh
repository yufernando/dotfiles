#!/bin/bash
USER=${1:-fer}

# Copy SSH Keys
if [[ -e /root/.ssh/authorized_keys ]]; then
    mkdir -p /home/$USER/.ssh
    sudo cp /root/.ssh/authorized_keys /home/$USER/.ssh/authorized_keys
    sudo chown $USER:$USER /home/$USER/.ssh/authorized_keys
fi

# Config and Install
cd /home/$USER
git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles.git .dotfiles
cd .dotfiles
./2_config.sh
./3_install.sh
