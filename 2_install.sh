#!/bin/bash
#
# INSTALLATION (2_install.sh)
# Install utilities in a linux server or mac computer
#----------------------------------------------------------------

echo ""
echo "2. INSTALLATION: installing utilities."
echo ""

UNAME=$(uname)

if [[ "$UNAME" == "Linux" ]]; then

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
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Change shell to zsh
chsh -s /usr/bin/zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

# Oh-my-zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

if [[ "$UNAME" == "Darwin" ]]; then
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install VIM
brew install neovim

# Install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim --headless +PlugInstall +qall > /dev/null 2>&1

# Install TMUX
brew install tmux

# Install zsh (need to reboot to change shell)
brew install zsh
chsh -s /usr/bin/zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Oh-my-zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-             ⤷ autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-     ⤷ syntax-highlighting

# Config oh-my-zsh
mkdir -p ~/.oh-my-zsh/custom/themes
ln -svf $PWD/oh-my-zsh/robbyrussell-userhost.zsh-theme  ~/.oh-my-zsh/custom/themes/robbyrussell-userhost.zsh-theme

fi
