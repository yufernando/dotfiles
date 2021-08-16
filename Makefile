# Makefile
# Arguments: 
# 	host=hostname
# 	user=username
# Example: make all host=test-server user=fer

# Defaults
user := fer

.PHONY: all
all: 
	./0_setup.sh $(host)
	./1_harden.sh
	./2_config.sh
	./3_install.sh
	sudo -u $(user) -H sh -c "./4_config_install_user.sh" $(user)
	echo "Installation complete. Relogin"

.PHONY: config_install_user
config_install_user:
	sudo -u $(user) -H sh -c "./4_config_install_user.sh" $(user)

.PHONY: clean
clean:
	rm -f ~/.zshrc*
	rm -rf ~/.oh-my-zsh
