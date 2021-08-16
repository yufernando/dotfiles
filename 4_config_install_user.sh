#!/bin/bash
USER=${1:-fer}

# Config and Install
cd /home/$USER
git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles.git .dotfiles
cd .dotfiles
./2_config.sh
./3_install.sh
