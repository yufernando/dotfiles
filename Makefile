# Dotfiles
# Install and configure a common environment across platforms.
#
# Help
#	make help
#
# Setup Mac or Docker Linux:
#	make install config
#
# Setup Ubuntu Server:
#	make all 
#		host=hostname
#		user=username
#		password=password 
#		[ignoreip=ignoreip]
#		[sshkey=sshkey] --> if configured in automated script
#
# Update config:
# 	make config
#
# Merge branch with master and push to remote
# 	make merge branch=mac
# 	make merge 		--> merges both mac and ubuntu
#
# Test scripts:
#   make test host=ubuntu-test user=fer password=abc123
#   make test-ssh   --> SSH into test container

SHELL := /bin/bash
skipplugins := ""

UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
DOTFILES_BRANCH := ubuntu
else ifeq ($(UNAME), Darwin)
DOTFILES_BRANCH := mac
endif
branch := all

.PHONY: help all all_root all_user install config merge
.PHONY: test-build test-run copy-ssh copy-dotfiles test-setup test-ssh

help: ## View help
	@awk 'BEGIN {FS="^#+ ?"; header=1; body=0}; \
		  header == 1 {printf "\033[36m%s\033[0m\n", $$2} \
		  /^#\s*$$/ {header=0; body=1; next} \
		  body == 1 && /^#+ ?[^ \t]/ {print $$2} \
		  body == 1 && /^#+( {2,}| ?\t)/ {printf "\033[0;37m%s\033[0m\n", $$2} \
		  /^\s*$$/ {print "";exit}' $(MAKEFILE_LIST)
	@echo "Rules:"
	@grep -E '^[a-zA-Z_-]+:.*##[ \t]+.*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS=":.*##[ \t]+"}; {printf "\033[36m%-20s\033[0m%s\n", $$1, $$2}'

ifeq ($(UNAME), Linux)
all: harden install config user ## Main entrypoint: install and config (Linux, also setup and harden)
	@echo "\nInstallation complete. Relogin."
else ifeq ($(UNAME), Darwin)
all: install config
	@echo "\nInstallation complete. Relogin."
endif

harden:
	@echo "\nConfiguring root.\n"
	@./scripts/0_setup.sh $(host)
	@./scripts/1_harden.sh --user $(user) --password $(password) --ignoreip "$(ignoreip)" --sshkey "$(sshkey)" 
	@./scripts/2_copy_ssh.sh $(user) $(sshkey)

install: ## Install programs. Clone dotfiles repo if not existent.
	@./scripts/3_install.sh

config: ## Configure settings. Clone dotfiles repo if not existent.
	./scripts/4_config.sh $(skipplugins)

user: ## Linux standard user: install and config.
	@echo "\nConfiguring user.\n"
	@echo $(password) | sudo -S -u $(user) -H bash -c \
		"git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles.git /home/$(user)/.dotfiles; 	\
		cd /home/$(user)/.dotfiles; 				\
		$(MAKE) install; 							\
		$(MAKE) config skipplugins=$(skipplugins)"

merge: ## Merge branch with master and push to remote
	@if [ "$(branch)" = "all" ]; then  \
		$(MAKE) merge branch=mac; \
		$(MAKE) merge branch=ubuntu; \
	else \
		git checkout $(branch); \
		git pull --ff-only; \
		git merge master --ff-only; \
		git push; \
		git checkout master; \
	fi

test-build: ## Build test image
	@if [ -z "$(password)" ]; then echo "Must provide a password. Example: make test-build password=mypass."; exit 1; fi;
	@echo "Building Docker image..."
	@docker build --quiet -t ubuntu:test scripts --build-arg password=$(password) > /dev/null

test-run: ## Run test container
	@echo "Removing previous containers and running new instance..."
	@docker stop ubuntu-test &> /dev/null || true
	@docker rm   ubuntu-test &> /dev/null || true
	@sleep 1
	@docker run --rm -d -it -p 2222:22 --name ubuntu-test ubuntu:test > /dev/null

test-copy-ssh: ## Copy SSH keys into test container
	@echo "Copying SSH keys..."
	@docker exec ubuntu-test mkdir -p /root/.ssh
	@scp -P 2222 ~/.ssh/id_rsa_linode.pub root@localhost:~/.ssh/authorized_keys

test-copy-dotfiles: ## Copy dotfiles to running test container
	@echo "Copying dotfiles..."
	@docker cp ~/.dotfiles ubuntu-test:/root/

test: ## Run full test setup
	@$(MAKE) test-build
	@$(MAKE) test-run
	@$(MAKE) test-copy-ssh
	@$(MAKE) test-copy-dotfiles
	docker exec -it ubuntu-test bash -c "cd /root/.dotfiles; make all host=$(host) user=$(user) password=$(password) skipplugins=$(skipplugins)"

test-ssh: ## SSH into test container
	@awk '!/localhost/' ~/.ssh/known_hosts > ~/.ssh/tmp && mv ~/.ssh/tmp ~/.ssh/known_hosts
	@echo "SSH into container..."
	@ssh -o StrictHostKeyChecking=no -o LogLevel=ERROR -p 2222 fer@localhost
