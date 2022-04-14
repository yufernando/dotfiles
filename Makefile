# Makefile
#
# Help
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
#	make install
#	make config     -> two steps for caching
#
# Mac: Update config
# 	make config
#
# Ubuntu: Update config
# 	make config
#
# Merge branch with master and push to remote
# 	make merge branch=mac

UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
DOTFILES_BRANCH := ubuntu
else ifeq ($(UNAME), Darwin)
DOTFILES_BRANCH := mac
endif

.PHONY: all all_root all_user install config install_config merge help

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

merge: ## Merge branch with master and push to remote
	git checkout $(branch)
	git pull
	git merge master
	git push
	git checkout master

help: ## View help
	@awk 'BEGIN {FS="^#+ ?"}; \
		  NR==1 {printf "\033[36m%s\033[0m\n\n", $$2; next} \
		  /^#+ ?[^ \t]/ {print $$2} \
		  /^#+( {2,}| ?\t)/ {printf "\033[0;37m%s\033[0m\n", $$2} \
		  /^\s*$$/ {print "";exit}' $(MAKEFILE_LIST)
	@echo "Rules:"
	@grep -E '^[a-zA-Z_-]+:.*##[ \t]+.*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS=":.*##[ \t]+"}; {printf "\033[36m%-20s\033[0m%s\n", $$1, $$2}'

