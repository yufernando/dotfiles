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

.PHONY: all all_root all_user config_install config clean

# Setup Ubuntu server
all: all_root all_user
	echo "Installation complete. Relogin"

all_root:
	./0_setup.sh $(host)
	./1_harden.sh
	./2_config.sh
	./3_install.sh

all_user:
	sudo -u $(user) -H sh -c \
		"cd /home/$(user); \
		git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles.git .dotfiles; \
		cd .dotfiles; \
		./2_config.sh; \
		./3_install.sh; \
		./4_copy_ssh $(user)"

# To setup Docker image
config_install:
	if [ ! -d ~/.dotfiles ]; then \
		git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles.git ~/.dotfiles; \
	fi
	cd ~/.dotfiles
	./2_config.sh
	./3_install.sh

# To recreate symlinks
config:
	./2_config.sh

clean:
	rm -f ~/.zshrc*
	rm -rf ~/.oh-my-zsh
