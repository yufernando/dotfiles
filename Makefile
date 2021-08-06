# Makefile
# Arguments: host=hostname
# Example: make install host=test-server

.PHONY: all
all: install

.PHONY: install
install: 
	./0_setup.sh $(host)
	./1_harden.sh
	./2_config.sh
	./3_install.sh
	sudo -u fer -H sh -c "./4_config_install_fer.sh"
	echo "Installation complete. Relogin"

.PHONY: clean
clean:
	rm -f ~/.zshrc*
	rm -rf ~/.oh-my-zsh
