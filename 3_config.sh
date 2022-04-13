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
if [[ "$OSTYPE" == "darwin"* ]]; then
ln -svf $DIR/zsh/zprofile               ~/.zprofile #Ruby, Rust and pyenv
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
ln -svf $PWD/oh-my-zsh/robbyrussell-userhost.zsh-theme  ~/.oh-my-zsh/custom/themes/robbyrussell-userhost.zsh-theme
fi
ln -svf $DIR/stata_kernel.conf          ~/.stata_kernel.conf
ln -svf $DIR/latexmkrc                  ~/.latexmkrc
#ln -svf $DIR/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py
#ln -svf $DIR/plugin.jupyterlab-settings ~/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension/plugin.jupyterlab-settings

# sudo ln -svf $DIR/nginx/ferserver       /etc/nginx/sites-enabled/ferserver

#Jupyterhub
#ln -svf $DIR/jupyterhub/jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py
#.dotfiles -> /srv -> /systemd
#sudo ln -svf $DIR/jupyterhub/jupyterhub.service /srv/jupyterhub/jupyterhub.service
#sudo ln -svf /srv/jupyterhub/jupyterhub.service /etc/systemd/system/jupyterhub.service  

# Tmux
if [[ "$OSTYPE" == "darwin"* ]]; then
ln -svf $DIR/tmux/tmux.conf.mac             ~/.tmux.conf
ln -svf $DIR/tmux/tunes.js              ~/.tmux/tunes.js
fi
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
ln -svf $DIR/tmux/tmux.conf.ubuntu          ~/.tmux.conf
fi

# Italics in iTerm and Tmux
# https://apple.stackexchange.com/a/267261
tic -o ~/.terminfo $DIR/tmux/xterm-256color.terminfo.txt || true
tic -o ~/.terminfo $DIR/tmux/tmux-256color.terminfo.txt || true
tic -o ~/.terminfo $DIR/tmux/tmux.terminfo.txt || true

# Ranger
ln -svf $DIR/ranger/rc.conf             ~/.config/ranger/rc.conf
ln -svf $DIR/ranger/commands.py         ~/.config/ranger/commands.py
ln -svf $DIR/vifmrc                     ~/.config/vifm/vifmrc
ln -svf $DIR/conda/condarc              ~/.condarc

if [[ "$OSTYPE" == "darwin"* ]]; then
# VSCode
ln -svf $DIR/settings.json              ~/Library/Application\Support/Code/User/settings.json
# Karabiner
ln -svf $DIR/karabiner.json             ~/.config/karabiner/karabiner.json
# Latex
ln -svf $DIR/thesis.sty                 ~/Library/texmf/tex/latex/local/thesis.sty
fi

# Vim
ln -svf $DIR/vim/vimrc                  ~/.vimrc
ln -svf $DIR/vim/init.vim               ~/.config/nvim/init.vim
ln -svf $DIR/vim/autocmds.vim           ~/.vim/autoload/autocmds.vim        

# Install Vim Plugins
echo "Installing Vim Plugins..."
nvim --headless +PlugInstall +qall > /dev/null 2>&1
