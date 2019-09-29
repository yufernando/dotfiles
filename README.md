# Description 
This repo contains my dotfiles. After cloning the repo, the file `install.sh` creates symlinks to the respective file locations.

# Installation

```
git clone git@github.com:yufernando/dotfiles.git
./install.sh
```

# Create Symlinks
The installation file `install.sh` creates symlinks such as:
```
ln -svf ~/.dotfiles/bash_profile ~/.bash_profile
ln -svf ~/.dotfiles/init.vim     ~/.config/nvim/init.vim
ln -svf ~/.dotfiles/tmux.conf    ~/.tmux.conf
ln -svf ~/.dotfiles/vimrc        ~/.vimrc
ln -svf ~/.dotfiles/zshrc        ~/.zshrc
