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
ln -svf $DIR/oh-my-zsh/robbyrussell-userhost.zsh-theme  ~/.oh-my-zsh/custom/themes/robbyrussell-userhost.zsh-theme

#Remote server
sudo ln -s /home/fer/.dotfiles/zshrc    /root/.zshrc
sudo ln -s /home/fer/.dotfiles/init.vim /root/.config/nvim/init.vim
#sudo ln -svf $DIR/nginx/ferserver       /etc/nginx/sites-enabled/ferserver

#Jupyterhub
sudo ln -svf $DIR/jupyterhub/jupyterhub_config-default.py /srv/jupyterhub/jupyterhub_config.py
#.dotfiles -> /srv -> /systemd
sudo ln -svf $DIR/jupyterhub/jupyterhub.service /srv/jupyterhub/jupyterhub.service
sudo ln -svf /srv/jupyterhub/jupyterhub.service /etc/systemd/system/jupyterhub.service  

# Italics in iTerm and Tmux
# https://apple.stackexchange.com/a/267261
tic -o ~/.terminfo xterm-256color.terminfo.txt
tic -o ~/.terminfo tmux-256color.terminfo.txt
tic -o ~/.terminfo tmux.terminfo.txt

echo "Installation complete! Relogin please"

# After installing Vim, run :PlugInstall
