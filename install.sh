#!/bin/bash

# In Linux

# Install utilities
#curl
sudo apt update
sudo apt install -Y curl python3-pip neovim git tmux zsh fzf 
#homebrew
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
#sudo apt-get install build-essential
#echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> /home/fer/.zprofile
#eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
#brew install gcc
#install pip

# Install fd
wget https://github.com/sharkdp/fd/releases/download/v8.2.1/fd-musl_8.2.1_amd64.deb
sudo dpkg -i fd-musl_8.2.1_amd64.deb

# Install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Change shell to zsh (need to reboot to change shell)
chsh -s /usr/bin/zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
