# Dotfiles

This repository contains scripts to setup and configure an Mac computer. It
contains scripts to install useful tools (zsh, tmux, etc) and dotfiles for configuration.

# Installation instructions

1. Clone the `master` branch of the repository into a hidden folder in the home directory:

```
git clone --single-branch --branch master https://github.com/yufernando/dotfiles ~/.dotfiles
```

2. Make sure you have `make` installed: 

```
brew install make
```

3. Run the config and install scripts:

```
cd ~/.dotfiles
make all
```

# Running the scripts separately

You can run the scripts individually.

### Configuration

The file `2_config.sh` creates symlinks to the respective file locations.
```
./2_config.sh
```

Equivalent to `make config`.

This creates symlinks such as:
```
ln -svf ~/.dotfiles/bash_profile ~/.bash_profile
ln -svf ~/.dotfiles/init.vim     ~/.config/nvim/init.vim
ln -svf ~/.dotfiles/tmux.conf    ~/.tmux.conf
ln -svf ~/.dotfiles/vimrc        ~/.vimrc
ln -svf ~/.dotfiles/zshrc        ~/.zshrc
```

### Installation of programs

The script `3_install.sh` installs useful utilities, including `oh-my-zsh` to customize the
`zsh` shell.

`./3_install.sh`

Equivalent to `make install`.
