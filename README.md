# Dotfiles

This repository contains scripts to setup and configure an Ubuntu Linux Machine. It
contains scripts to install useful tools (zsh, tmux, etc) and dotfiles for configuration.

# Installation instructions

1. `ssh` into your Linux box:

`ssh root@ip-address`

2. Clone the `ubuntu` branch of the repository into a hidden folder in the home directory:

```
git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles ~/.dotfiles
```

3. Install `make`: 

```
apt update && apt upgrade
apt install make
```

4. Run the scripts. The argument `host` defines the server name, in this example `test-server`:

```
cd ~/.dotfiles
make install host=test-server
```

5. Post-installation: 

- Relogin to test configuration success. 
- Open vim and run `:PlugInstall` to install plugins for both root and sudo user.

# Running the scripts separately

You can run the scripts individually.

### Setup

`0_setup.sh` sets basic information including hostname and timezone.

### Hardening

`1_harden.sh` sets up the ufw firewall and configures ssh.

### Configuration

The file `2_config.sh` creates symlinks to the respective file locations.
```
./2_config.sh
```

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

