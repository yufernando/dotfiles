# Makefile
# Usage: make all

.PHONY: all
all: config install

.PHONY: config
config:
	./2_config.sh

.PHONY: install
install:
	./3_install.sh
