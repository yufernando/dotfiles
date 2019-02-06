#!/bin/bash

echo "Installing dotfiles..."

DIR=$PWD

# Installation

git clone git@github.com:yufernando/dotfiles.git

# Create Symlinks

ln -sf $DIR/bash_profile ~/.bash_profile
ln -sf $DIR/init.vim     ~/.config/nvim/init.vim
ln -sf $DIR/tmux.conf    ~/.tmux.conf
ln -sf $DIR/vimrc        ~/.vimrc
ln -sf $DIR/zshrc        ~/.zshrc

echo "Installation complete! Relogin please"
