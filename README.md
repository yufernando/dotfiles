# Description 
This repository contains scripts to install useful tools (zsh, tmux, etc) and dotfiles for configuration.

Begin by cloning the repository into a hidden folder in the home directory:

```
cd ~
git clone https://github.com/yufernando/dotfiles
mv dotfiles .dotfiles
```

# Installation

```
make install
```

# Details

You can run the scripts individually.

## Configuration

After cloning the repo, the file `config.sh` creates symlinks to the respective file locations.

```
./config.sh
```

This creates symlinks such as:
```
ln -svf ~/.dotfiles/bash_profile ~/.bash_profile
ln -svf ~/.dotfiles/init.vim     ~/.config/nvim/init.vim
ln -svf ~/.dotfiles/tmux.conf    ~/.tmux.conf
ln -svf ~/.dotfiles/vimrc        ~/.vimrc
ln -svf ~/.dotfiles/zshrc        ~/.zshrc
```

## Installation of programs

The script `install.sh` installs useful utilities.

`./install.sh`

