# Makefile
#
# Examples: 
#
# - Setup Ubuntu Server:
#
#	make all 
# 		host=hostname
# 		user=username
# 		password=password 
# 		[ignoreip=ignoreip]
# 		[sshkey=sshkey] # if configured in automated script
#
# - Setup Docker image:
#
# 		make install_config

.PHONY: all all_root all_user install_config config clean

# Setup Ubuntu server
all: all_root all_user
	@echo "\nInstallation complete. Relogin."

all_root:
	@echo "\nConfiguring root.\n"
	@./0_setup.sh $(host)
	@./1_harden.sh --user $(user) --password $(password) --ignoreip "$(ignoreip)" --sshkey "$(sshkey)" 
	@./2_install.sh
	@./3_config.sh
	@./4_copy_ssh.sh $(user) $(sshkey)

all_user:
	@echo "\nConfiguring user.\n"
	@echo $(password) | sudo -S -u $(user) -H sh -c \
		"cd /home/$(user); \
		git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles.git .dotfiles; \
		cd .dotfiles; \
		./2_install.sh; \
		./3_config.sh"

# To setup Docker image
install_config:
	if [ ! -d ~/.dotfiles ]; then \
		git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles.git ~/.dotfiles; \
	fi
	cd ~/.dotfiles
	./2_install.sh
	./3_config.sh

# Install programs
install:
	./2_install.sh

# To recreate symlinks
config:
	./3_config.sh
