# Makefile
# Arguments: host=hostname
# Example: make all host=test-server

.PHONY: all
all: 
	./0_setup.sh $(host)
	./1_harden.sh
	./2_config.sh
	./3_install.sh
	sudo -u fer -H sh -c "./4_config_install_fer.sh"
	echo "Installation complete. Relogin"

.PHONY: config
config:
	./2_config.sh

.PHONY: install
install:
	./3_install.sh

.PHONY: clean
clean:
	rm -f ~/.zshrc*
	rm -rf ~/.oh-my-zsh
