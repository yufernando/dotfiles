# Makefile
#
# Arguments: 
# 	host=hostname
# 	user=username
#
# Examples: 
# - Setup Ubuntu Server:
# 		make all host=test-server user=fer 
# - Setup Docker image
# 		make config_install user=fer

# Defaults
user := fer

# Setup Ubuntu server
.PHONY: all
all: 
	./0_setup.sh $(host)
	./1_harden.sh
	./2_config.sh
	./3_install.sh
	sudo -u $(user) -H sh -c \
		"cd /home/$(user); \
		git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles.git .dotfiles; \
		cd .dotfiles; \
		./2_config.sh; \
		./3_install.sh; \
		./4_copy_ssh $(user)"
	echo "Installation complete. Relogin"

# To setup Docker image
.PHONY: config_install
config_install:
	if [ ! -d ~/.dotfiles ]; then \
		git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles.git ~/.dotfiles; \
	fi
	cd ~/.dotfiles
	./2_config.sh
	./3_install.sh

.PHONY: clean
clean:
	rm -f ~/.zshrc*
	rm -rf ~/.oh-my-zsh
