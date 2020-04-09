#!/bin/bash

# In Linux

# Install VIM
sudo apt install neovim

# Install git
sudo apt install git

# Install TMUX
sudo apt install tmux

# Install zsh (need to reboot to change shell)
sudo apt install zsh -Y
chsh -s /usr/bin/zsh

# Install oh-my-zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
