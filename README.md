# Dotfiles

This repository contains scripts configure the same environment in a Mac, Ubuntu Server or Docker container. It installs useful tools (zsh, tmux, etc) and dotfiles for configuration.

In addtion, in an Ubuntu server it configures and hardens the server (sets up SSH and firewall).

# Installation instructions

## Mac

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

## Ubuntu Linux

1. Copy your SSH public key to the Linux box. If you set SSH keys from the console manager or using
   an automated script this step is not necessary:

```
scp ~/.ssh/id_rsa.pub root@ip-address:~/.ssh/authorized_keys
```

2. `ssh` into your Linux box:

```
ssh root@ip-address
```

3. Install `git` and `make`: 

```
apt update && apt -y upgrade
apt -y install git make
```

4. Clone the `ubuntu` branch of the repository into a hidden folder in the home directory:

```
git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles ~/.dotfiles
```

5. Run the scripts. The argument `host` defines the server name. The argument `user` defines the local user to configure in addition to `root`. `ignoreip` is an ip-address that should be ignored by Fail2ban.

```
cd ~/.dotfiles
make all host=hostname user=username password=password [ignoreip=ignoreip] [sshkey=sshkey]
```
The last argument `sshkey` is only needed when configured through an automated script.

# Running the scripts separately

You can run the scripts individually.

### Setup (Linux Server)

`0_setup.sh` sets basic information including hostname and timezone.

### Hardening (Linux Server)

`1_harden.sh` sets up the ufw firewall and configures ssh.

### Installation of programs

The script `2_install.sh` installs useful utilities, including `oh-my-zsh` to customize the
`zsh` shell.

`./2_install.sh`

Equivalent to `make install`.

### Configuration

The file `3_config.sh` creates symlinks to the respective file locations.
```
./3_config.sh
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

# Configure a Docker Container

To configure a Docker container running Ubuntu with zsh, oh-my-zsh and other utilities clone the
repository and run the `config_install` recipe:
```
apt update && apt -y upgrade
apt -y install make
git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles ~/.dotfiles
cd ~/.dotfiles
make install config user=username
```

The two `make` steps are intentional to exploit caching of the install step and avoid rebuilding every time we change the configuration step.
