# Dotfiles

This repository contains scripts to configure the same environment in a Mac, Ubuntu Server or Docker container. It installs useful tools (zsh, tmux, etc) and dotfiles for configuration.

In addition, in an Ubuntu server it configures and hardens the server (sets up SSH and firewall).

All scripts can be run from the `master` branch which has flags for every type of OS/platform. The instructions below make specific mention to an `ubuntu` branch just in case we want to customize further in the future but it is not necessary.

For specific implementation details run `make help`.

# Installation instructions

## Mac

1. Clone the `master` branch and install make:

```
git clone --single-branch --branch master https://github.com/yufernando/dotfiles ~/.dotfiles
brew install make
cd ~/.dotfiles
```

2. (a) Run a full installation and configuration:

```
make all
```

2. (b) To just run configuration:

```
make config
```

## Docker Container

1. Install required programs and clone the repository:
```
apt update && apt -y upgrade
apt -y install make
git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles ~/.dotfiles
cd ~/.dotfiles
```

2. Run full installation and configuration:
```
make install config
```
The two `make` steps should be kept separate in a Dockerfile to exploit caching.

## Ubuntu Linux

1. Copy your SSH public key to the Linux box and SSH in. If you set SSH keys from the console manager or using an automated script this first step is not necessary:

```
scp ~/.ssh/id_rsa.pub root@ip-address:~/.ssh/authorized_keys
ssh root@ip-address
```

2. Install required programs and clone the repository:

```
apt update && apt -y upgrade
apt -y install git make
git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles ~/.dotfiles
cd ~/.dotfiles
```

3. Run a full installation and configuration including SSH hardening and firewall with the following arguments:
- `host`: server name. 
- `user`: local username to configure in addition to `root`. 
- `ignoreip`: ip-address that should be ignored by Fail2ban.

```
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

