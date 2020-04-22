#!/bin/bash

echo "Installing dotfiles..."

DIR=$PWD

# Installation

#./install.sh

# Configuration

# Create config files
#Vim
mkdir -p ~/.config/nvim/
touch ~/.config/nvim/init.vim
mkdir -p ~/.vim/autoload/
touch ~/.vim/autoload/autocmds.vim
#Tmux
touch ~/.tmux.conf
#zshrc
touch ~/.zshrc

# Create Symlinks

ln -svf $DIR/bash_profile               ~/.bash_profile
ln -svf $DIR/gitconfig                  ~/.gitconfig
ln -svf $DIR/zshrc                      ~/.zshrc
ln -svf $DIR/vimrc                      ~/.vimrc
ln -svf $DIR/init.vim                   ~/.config/nvim/init.vim
ln -svf $DIR/vim/autocmds.vim           ~/.vim/autoload/autocmds.vim        
ln -svf $DIR/tmux.conf                  ~/.tmux.conf
ln -svf $DIR/tmux/tunes.js              ~/.tmux/tunes.js
ln -svf $DIR/stata_kernel.conf          ~/.stata_kernel.conf
ln -svf $DIR/latexmkrc                  ~/.latexmkrc
ln -svf $DIR/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py
ln -svf $DIR/plugin.jupyterlab-settings ~/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension/plugin.jupyterlab-settings
ln -svf $DIR/settings.json              ~/Library/Application\Support/Code/User/settings.json
ln -svf $DIR/karabiner.json             ~/.config/karabiner/karabiner.json
ln -svf $DIR/thesis.sty                 ~/Library/texmf/tex/latex/local/thesis.sty
ln -svf $DIR/ranger/rc.conf             ~/.config/ranger/rc.conf
ln -svf $DIR/ranger/commands.py         ~/.config/ranger/commands.py
ln -svf $DIR/vifmrc                     ~/.config/vifm/vifmrc

# Italics in iTerm and Tmux
# https://medium.com/@dubistkomisch/how-to-actually-get-italics-and-true-colour-to-work-in-iterm-tmux-vim-9ebe55ebc2be
mv ~/.terminfo ~/.terminfo-backup
rm -rf ~/.terminfo
tic -x -o ~/.terminfo $DIR/terminfo/xterm-256color.terminfo
tic -x -o ~/.terminfo $DIR/terminfo/tmux-256color.terminfo
tic -x -o ~/.terminfo $DIR/terminfo/tmux.terminfo
# Check with
# export $TERM
# echo `tput sitm`italics`tput ritm`

echo "Installation complete! Relogin please"

# After installing Vim, run :PlugInstall
