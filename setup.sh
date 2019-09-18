#!/bin/bash

echo "Installing dotfiles..."

DIR=$PWD

# Installation

# git clone git@github.com:yufernando/dotfiles.git

# Create Symlinks

ln -svf $DIR/bash_profile               ~/.bash_profile
ln -svf $DIR/init.vim                   ~/.config/nvim/init.vim
ln -svf $DIR/tmux.conf                  ~/.tmux.conf
ln -svf $DIR/vimrc                      ~/.vimrc
ln -svf $DIR/zshrc                      ~/.zshrc
ln -svf $DIR/vim/autocmds.vim           ~/.vim/autoload/autocmds.vim        
ln -svf $DIR/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py
ln -svf $DIR/tmux/tunes.js              ~/.tmux/tunes.js
ln -svf $DIR/latexmkrc                  ~/.latexmkrc
ln -svf $DIR/plugin.jupyterlab-settings ~/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension/plugin.jupyterlab-settings

# Italics in iTerm and Tmux
# https://apple.stackexchange.com/a/267261
tic -o ~/.terminfo xterm-256color.terminfo.txt
tic -o ~/.terminfo tmux-256color.terminfo.txt
tic -o ~/.terminfo tmux.terminfo.txt

echo "Installation complete! Relogin please"
