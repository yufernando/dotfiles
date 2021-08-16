# Makefile
# Arguments: 
# 	host=hostname
# 	user=username
# Examples: 
# 	make all host=test-server user=fer
# 	make config_install user=fer

# Defaults
user := fer

.PHONY: all
all: 
	./0_setup.sh $(host)
	./1_harden.sh
	./2_config.sh
	./3_install.sh
	# sudo -u $(user) -H sh -c "./4_config_install_user.sh" $(user)
	sudo -u $(user) -H sh -c '
		cd /home/$(user)
		git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles.git .dotfiles
		cd .dotfiles
		./2_config.sh
		./3_install.sh
		./4_copy_ssh $(user)'
	echo "Installation complete. Relogin"

.PHONY: config_install
config_install:
	# Root
	./2_config.sh
	./3_install.sh
	# User
	sudo -u $(user) -H sh -c '
		cd /home/$(user)
		git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles.git .dotfiles
		cd .dotfiles
		./2_config.sh
		./3_install.sh'

.PHONY: clean
clean:
	rm -f ~/.zshrc*
	rm -rf ~/.oh-my-zsh
