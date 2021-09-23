#!/bin/bash
#
# CONFIGURATION (3_config.sh)
# Create symlinks to configure programs
#----------------------------------------------------------------

echo ""
echo "3. CONFIGURATION: Creating symlinks."
echo ""

DIR=$PWD

# Create directories and files

# Vim
mkdir -p ~/.config/nvim/
touch ~/.config/nvim/init.vim
mkdir -p ~/.vim/autoload/
touch ~/.vim/autoload/autocmds.vim
# Tmux
touch ~/.tmux.conf
# Zshrc
touch ~/.zshrc
# Oh-my-zsh
mkdir -p ~/.oh-my-zsh/custom/themes

# Create Symlinks

ln -svf $DIR/bash_profile               ~/.bash_profile
ln -svf $DIR/gitconfig                  ~/.gitconfig
ln -svf $DIR/zsh/zshrc                  ~/.zshrc
ln -svf $PWD/oh-my-zsh/robbyrussell-userhost.zsh-theme  ~/.oh-my-zsh/custom/themes/robbyrussell-userhost.zsh-theme
ln -svf $DIR/vim/vimrc                  ~/.vimrc
ln -svf $DIR/vim/init.vim               ~/.config/nvim/init.vim
ln -svf $DIR/vim/autocmds.vim           ~/.vim/autoload/autocmds.vim        
ln -svf $DIR/stata_kernel.conf          ~/.stata_kernel.conf
ln -svf $DIR/latexmkrc                  ~/.latexmkrc
#ln -svf $DIR/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py
#ln -svf $DIR/plugin.jupyterlab-settings ~/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension/plugin.jupyterlab-settings
#ln -svf $DIR/thesis.sty                 ~/Library/texmf/tex/latex/local/thesis.sty
# sudo ln -svf $DIR/nginx/ferserver       /etc/nginx/sites-enabled/ferserver

#Jupyterhub
#ln -svf $DIR/jupyterhub/jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py
#.dotfiles -> /srv -> /systemd
#sudo ln -svf $DIR/jupyterhub/jupyterhub.service /srv/jupyterhub/jupyterhub.service
#sudo ln -svf /srv/jupyterhub/jupyterhub.service /etc/systemd/system/jupyterhub.service  

# Tmux
ln -svf $DIR/tmux/tmux.conf             ~/.tmux.conf
# Italics in iTerm and Tmux
# https://apple.stackexchange.com/a/267261
tic -o ~/.terminfo $DIR/tmux/xterm-256color.terminfo.txt || true
tic -o ~/.terminfo $DIR/tmux/tmux-256color.terminfo.txt || true
tic -o ~/.terminfo $DIR/tmux/tmux.terminfo.txt || true
