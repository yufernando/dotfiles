#!/bin/bash
#
# INSTALLATION (2_install.sh)
# Install utilities in a Linux server or Mac computer
#----------------------------------------------------------------

set -euo pipefail

echo ""
echo "2. INSTALLATION: Installing utilities."
echo ""

echo "Skipping if programs already installed."

if [[ "$OSTYPE" == "linux-gnu"* ]]; then

# Update and upgrade
DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y upgrade

# Neovim 
# Add neovim PPA repository
DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common
add-apt-repository -y ppa:neovim-ppa/stable

# Essential Linux Programs, Python and prerequisites for Neovim Python modules
DEBIAN_FRONTEND=noninteractive apt-get -y install \
    python python3 python-dev python3-dev python3-pip \
    neovim curl git tmux zsh ripgrep fzf fd-find build-essential && \
    pip install pynvim # Vim python package

# Create symlink to fd
mkdir -p ~/.local/bin
ln -sf $(which fdfind) ~/.local/bin/fd

# Install vim-plug
if [ ! -e $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

# Change shell to zsh
if [[ $SHELL != /bin/zsh ]]; then
    chsh -s /usr/bin/zsh
fi
if [ -f /.docker-date-created ]; then
    echo "export HOST=$(cat /etc/hostname)" >> ~/.dotfiles/zsh/zshrc
fi

# Install oh-my-zsh
if [ ! -e $HOME/.oh-my-zsh/oh-my-zsh.sh ]; then
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

# Oh-my-zsh plugins
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi
fi

if [[ "$OSTYPE" == "darwin"* ]]; then

# Homebrew
if ! type brew > /dev/null; then
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install VIM
if ! type nvim > /dev/null; then
brew install neovim
fi

# Install vim-plug
if [ ! -e $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi
nvim --headless +PlugInstall +qall > /dev/null 2>&1

# Install TMUX
if ! type tmux > /dev/null; then
brew install tmux
fi

# Install zsh (need to reboot to change shell)
if ! type zsh > /dev/null; then
brew install zsh
fi
if [[ $SHELL != /bin/zsh ]]; then
chsh -s /usr/bin/zsh
fi

# Install oh-my-zsh
if [ ! -e $HOME/.oh-my-zsh/oh-my-zsh.sh ]; then
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Oh-my-zsh plugins
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi
fi
