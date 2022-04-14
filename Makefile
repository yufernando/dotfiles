# Makefile
#
# Help:
#	make help
#
# Setup Mac:
#	make all
#
# Setup Ubuntu Server:
#	make all 
#		host=hostname
#		user=username
#		password=password 
#		[ignoreip=ignoreip]
#		[sshkey=sshkey] # if configured in automated script
#
# Setup Docker image:
#		make install
#		make config     -> two steps for caching
#
# Mac: Update install and config
# 	make install config
#
# Ubuntu: Update install and config
# 	make install config

UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
DOTFILES_BRANCH := ubuntu
else ifeq ($(UNAME), Darwin)
DOTFILES_BRANCH := mac
endif

.PHONY: all all_root all_user install config install_config help

ifeq ($(UNAME), Linux)
all: all_root all_user ## Main entrypoint: install and config (Linux, also setup and harden)
	@echo "\nInstallation complete. Relogin."
else ifeq ($(UNAME), Darwin)
all: install config
	@echo "\nInstallation complete. Relogin."
endif

all_root: ## Linux root user: setup, harden, install and config.
	@echo "\nConfiguring root.\n"
	@./0_setup.sh $(host)
	@./1_harden.sh --user $(user) --password $(password) --ignoreip "$(ignoreip)" --sshkey "$(sshkey)" 
	@./2_install.sh
	@./3_config.sh
	@./4_copy_ssh.sh $(user) $(sshkey)

all_user: ## Linux standard user: install and config.
	@echo "\nConfiguring user.\n"
	@echo $(password) | sudo -S -u $(user) -H sh -c \
		"cd /home/$(user); \
		git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles.git .dotfiles; \
		cd .dotfiles; \
		./2_install.sh; \
		./3_config.sh"

install: ## Install programs. Clone dotfiles repo if not existent.
	@if [ ! -d ~/.dotfiles ]; then \
		git clone --single-branch --branch $(DOTFILES_BRANCH) https://github.com/yufernando/dotfiles.git ~/.dotfiles; \
	fi
	@./2_install.sh

config: ## Configure settings. Clone dotfiles repo if not existent.
	@if [ ! -d ~/.dotfiles ]; then \
		git clone --single-branch --branch $(DOTFILES_BRANCH) https://github.com/yufernando/dotfiles.git ~/.dotfiles; \
	fi
	@./3_config.sh

help: ## View help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

