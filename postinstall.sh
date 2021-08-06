#!/bin/bash

# Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# Config oh-my-zsh
mkdir -p ~/.oh-my-zsh/custom/themes
ln -svf $PWD/oh-my-zsh/robbyrussell-userhost.zsh-theme  ~/.oh-my-zsh/custom/themes/robbyrussell-userhost.zsh-theme

# Relink zshrc
ln -svf $PWD/zshrc                      ~/.zshrc
