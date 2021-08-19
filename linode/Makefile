# Usage:
# 	make create label=myserver
# 	make keys ip=ip
# 	make setup ip=ip host=host user=user pass=pass [ignoreip=ignoreip]
#
.PHONY: create
create:
	linode-cli linodes create --label $(label) --root_pass

.PHONY: keys
keys:
	scp ~/.ssh/id_rsa_linode.pub root@$(ip):~/.ssh/authorized_keys

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
