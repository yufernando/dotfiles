#!/bin/bash

# In Linux

# Install utilities
#curl
#sudo apt install curl
#homebrew
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
#sudo apt-get install build-essential
#echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> /home/fer/.zprofile
#eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
#brew install gcc

# Install pip and neovim
sudo apt -y install python3-pip neovim

# Install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Install git
sudo apt install git

# Install TMUX
sudo apt install tmux

# Install zsh (need to reboot to change shell)
sudo apt --yes install zsh
chsh -s /usr/bin/zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

# Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# Config oh-my-zsh
mkdir -p ~/.oh-my-zsh/custom/themes
ln -svf $PWD/oh-my-zsh/robbyrussell-userhost.zsh-theme  ~/.oh-my-zsh/custom/themes/robbyrussell-userhost.zsh-theme

# Relink zshrc: not necessary if oh-my-zsh installation with --unattended option
#ln -svf $PWD/zshrc                      ~/.zshrc
