#!/bin/bash

echo "Installing dotfiles..."

DIR=$PWD

# Installation

# git clone git@github.com:yufernando/dotfiles.git

# Create Symlinks

ln -svf $DIR/bash_profile ~/.bash_profile
ln -svf $DIR/init.vim     ~/.config/nvim/init.vim
ln -svf $DIR/tmux.conf    ~/.tmux.conf
ln -svf $DIR/vimrc        ~/.vimrc
ln -svf $DIR/zshrc        ~/.zshrc
ln -svf $DIR/vim/autocmds.vim ~/.vim/autoload/autocmds.vim        
ln -svf $DIR/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py
ln -svf $DIR/tmux/tunes.js ~/.tmux/tunes.js

echo "Installation complete! Relogin please"
