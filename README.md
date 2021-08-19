# Dotfiles

This repository contains scripts to setup, harden, configure and install utilities in an Ubuntu
Linux Machine. It configures the server, sets up SSH and a firewall and installs useful tools (zsh,
tmux, etc) and dotfiles for configuration.

# Installation instructions

1. Copy your SSH public key to the Linux box. If you set SSH keys from the console manager or using
   an automated script this step is not necessary:

`scp ~/.ssh/id_rsa.pub root@ip-address:~/.ssh/authorized_keys`

2. `ssh` into your Linux box:

`ssh root@ip-address`

3. Clone the `ubuntu` branch of the repository into a hidden folder in the home directory:

```
git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles ~/.dotfiles
```

4. Install `make`: 

```
apt update && apt upgrade
apt install make
```

5. Run the scripts. The argument `host` defines the server name. The argument `user` defines the local user to configure in addition to `root`. `ignoreip` is an ip-address that should be ignored by Fail2ban.

```
cd ~/.dotfiles
make all host=hostname user=username password=password [ignoreip=ignoreip] [sshkey=sshkey]
```
The last argument `sshkey` is only needed when configured through an automated script.

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

