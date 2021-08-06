#!/bin/bash

# Copy SSH Keys
mkdir -p /home/fer/.ssh
sudo cp /root/.ssh/authorized_keys /home/fer/.ssh/authorized_keys
sudo chown fer:fer /home/fer/.ssh/authorized_keys
cd /home/fer
git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles.git .dotfiles
cd .dotfiles
./2_config.sh
./3_install.sh
