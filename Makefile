.PHONY: install
install: 
	./config.sh
	./install.sh

.PHONY: clean
clean:
	rm -f ~/.zshrc*
	rm -rf ~/.oh-my-zsh
