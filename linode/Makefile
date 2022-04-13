# Makefile to deploy Linodes
#
# Usage: 
#
# Automated scripts:
# 	make deploy 		# Optional: include IGNOREIP in .env file
# 	make ssh [hostname=hostname]
# 	make status
#
# Manual scripts:
# 	make create label=myserver
# 	make keys ip=ip
# 	make setup ip=ip host=host user=user pass=pass [ignoreip=ignoreip]
#
# Environment Variables:
#
# Put the following in an .env file.
# USERNAME=
# STACKSCRIPT_ID=
# REGION=
# IMAGE=
# PLAN=
# SSHKEY=optional
# IGNOREIP=optional

# Deploy a new linode using configuration in .env file
.PHONY: deploy
deploy:
	@./deploy.sh

.PHONY: ssh
ssh:
	@./ssh_into_linode.sh $(hostname)

.PHONY: logs
logs:
	@./ssh_into_linode.sh -l $(hostname)

.PHONY: list
list:
	@linode-cli linodes list

# Create a new Linode
.PHONY: create
create:
	linode-cli linodes create --label $(label) --root_pass

# Copy SSH keys
.PHONY: keys
keys:
	scp ~/.ssh/id_rsa_linode.pub root@$(ip):~/.ssh/authorized_keys

# Configure newly created Linode
.PHONY: setup
setup:
	ssh root@$(ip) \
		"apt update; \
		DEBIAN_FRONTEND=noninteractive \
		  apt-get \
		  -o Dpkg::Options::=--force-confold \
		  -o Dpkg::Options::=--force-confdef \
		  -y --allow-downgrades --allow-remove-essential --allow-change-held-packages; \
		apt -y install git make; \
		git clone --single-branch --branch ubuntu https://github.com/yufernando/dotfiles ~/.dotfiles; \
		cd ~/.dotfiles; \
		make all host=$(host) user=$(user) password=$(pass) ignoreip=$(ignoreip);"
