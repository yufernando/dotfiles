#!/bin/bash
#
# CONFIGURATION (4_config.sh)
# Create symlinks to configure programs
#----------------------------------------------------------------

set -euo pipefail

echo ""
echo "3. CONFIGURATION: Creating symlinks."
echo ""

DIR=$PWD

# Create directories and files
mkdir -p ~/.config/nvim/            # Nvim
touch ~/.config/nvim/init.vim
mkdir -p ~/.vim/autoload/           # Vim
touch ~/.vim/autoload/autocmds.vim
touch ~/.tmux.conf                  # Tmux
touch ~/.zshrc                      # Zsh
mkdir -p ~/.oh-my-zsh/custom/themes # Oh-my-zsh
mkdir -p ~/.config/ranger           # Ranger
mkdir -p ~/.config/vifm             # Vifm

# Create Symlinks

ln -svf $DIR/bash/bash_profile          ~/.bash_profile
ln -svf $DIR/git/gitconfig              ~/.gitconfig
ln -svf $DIR/zsh/zshrc                  ~/.zshrc
if [[ "$OSTYPE" == "darwin"* ]]; then
    ln -svf $DIR/zsh/zprofile           ~/.zprofile #Ruby, Rust and pyenv
fi

ln -svf $PWD/oh-my-zsh/robbyrussell-userhost.zsh-theme  ~/.oh-my-zsh/custom/themes/robbyrussell-userhost.zsh-theme
ln -svf $DIR/jupyter/stata_kernel.conf  ~/.stata_kernel.conf
ln -svf $DIR/latex/latexmkrc            ~/.latexmkrc

# Tmux
if [[ "$OSTYPE" == "darwin"* ]]; then
    ln -svf $DIR/tmux/tmux.conf.mac     ~/.tmux.conf
    ln -svf $DIR/tmux/tunes.js          ~/.tmux/tunes.js
fi
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ln -svf $DIR/tmux/tmux.conf.ubuntu  ~/.tmux.conf
fi

# Italics in iTerm and Tmux
# https://apple.stackexchange.com/a/267261
if [[ "$OSTYPE" == "darwin"* ]]; then
    tic -o ~/.terminfo $DIR/tmux/tmux-256color.terminfo_mac.txt || true
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    tic -o ~/.terminfo $DIR/tmux/tmux-256color.terminfo_ubuntu.txt || true
fi
tic -o ~/.terminfo $DIR/tmux/xterm-256color.terminfo.txt || true
tic -o ~/.terminfo $DIR/tmux/tmux.terminfo.txt || true

# Ranger
ln -svf $DIR/ranger/rc.conf             ~/.config/ranger/rc.conf
ln -svf $DIR/ranger/commands.py         ~/.config/ranger/commands.py
ln -svf $DIR/vifm/vifmrc                ~/.config/vifm/vifmrc

# Conda
if [[ "$OSTYPE" == "darwin"* ]]; then
    ln -svf $DIR/conda/condarc          ~/.condarc
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ln -svf $DIR/conda/condarc_linux    ~/.condarc
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    # VSCode
    ln -svf $DIR/vscode/settings.json       ~/Library/Application\Support/Code/User/settings.json
    # Karabiner
    ln -svf $DIR/karabiner/karabiner.json   ~/.config/karabiner/karabiner.json
    # Latex
    ln -svf $DIR/latex/thesis.sty           ~/Library/texmf/tex/latex/local/thesis.sty
fi

# Vim
ln -svf $DIR/vim/vimrc                  ~/.vimrc
ln -svf $DIR/vim/init.vim               ~/.config/nvim/init.vim
ln -svf $DIR/vim/autocmds.vim           ~/.vim/autoload/autocmds.vim        

# Install Vim Plugins
echo "Installing Vim Plugins..."
nvim --headless +PlugInstall         +qall > /dev/null 2>&1
nvim --headless +UpdateRemotePlugins +qall > /dev/null 2>&1

# EXTRA

# Jupyter
#ln -svf $DIR/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py
#ln -svf $DIR/plugin.jupyterlab-settings ~/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension/plugin.jupyterlab-settings

#Jupyterhub
#sudo ln -svf $DIR/nginx/ferserver       /etc/nginx/sites-enabled/ferserver
#ln -svf $DIR/jupyterhub/jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py
#.dotfiles -> /srv -> /systemd
#sudo ln -svf $DIR/jupyterhub/jupyterhub.service /srv/jupyterhub/jupyterhub.service
#sudo ln -svf /srv/jupyterhub/jupyterhub.service /etc/systemd/system/jupyterhub.service  
