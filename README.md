# Dotfiles

This repository contains scripts to configure a common environment in a Mac, Ubuntu Server or Docker container. It installs useful tools (zsh, tmux, etc) and dotfiles for configuration.

In addition, it can harden an Ubuntu server (set up SSH and firewall).

All scripts can be run from the `master` branch which has flags for every type of OS/platform. The instructions below mention an `ubuntu` branch in case we want to customize further in the future but it is not necessary.

For specific implementation details run `make help`.

# Installation instructions

1. Install required programs:

- Mac: `brew install make`
- Linux: `apt update && apt -y upgrade && apt install -y git make`

2. Clone the repository:

```
git clone --single-branch --branch master https://github.com/yufernando/dotfiles ~/.dotfiles
cd ~/.dotfiles
```

2. Install and configure programs:

```
make install config
```

To just run configuration `make config`, which is idempotent.


## Hardening

In addition to install and config, you can also harden a fresh Linux box: set up SSH and firewall.

1. Copy your SSH public key to the Linux box and SSH in. If you set SSH keys from the console manager or using an automated script this first step is not necessary:

```
scp ~/.ssh/id_rsa.pub root@ip-address:~/.ssh/authorized_keys
ssh root@ip-address
```

2. Clone the repository as above.

3. Run hardening, install and config for both root and user with arguments:
- `host`: server name. 
- `user`: local username to configure in addition to `root`. 
- `ignoreip`: ip-address that should be ignored by Fail2ban.

```
make all host=hostname user=username password=password [ignoreip=ignoreip] [sshkey=sshkey]
```
The last argument `sshkey` is only needed when configured through an automated script.

# Running the scripts separately

You can run the scripts individually.

### 0. Setup (Linux Server)

`0_setup.sh` sets basic information including hostname and timezone.

### 1. Hardening (Linux Server)

`1_harden.sh` sets up the ufw firewall and configures ssh.

### 2. Copy SSH keys to user

### 3. Installation of programs

The script `3_install.sh` installs useful utilities, including `oh-my-zsh` to customize the
`zsh` shell.

`./3_install.sh`

Equivalent to `make install`.

### 4. Configuration

The file `4_config.sh` creates symlinks to the respective file locations.
```
./4_config.sh
```

Equivalent to `make config`.

This idempotent operation creates symlinks such as:
```
ln -svf ~/.dotfiles/bash_profile ~/.bash_profile
ln -svf ~/.dotfiles/init.vim     ~/.config/nvim/init.vim
ln -svf ~/.dotfiles/tmux.conf    ~/.tmux.conf
ln -svf ~/.dotfiles/vimrc        ~/.vimrc
ln -svf ~/.dotfiles/zshrc        ~/.zshrc
```

# Testing the scripts

Instead of testing in a remote VM, you can test the scripts locally in a Docker container using the following recipes:
```
make test host=[hostname] user=[username] password=[password]
make test-ssh
```

# Tips

For Dockerfiles it is useful to separate `make install` and `make config` to exploit caching.

After editing the dotfiles, run `make merge` to sync and push the `mac` and `ubuntu` branches.
