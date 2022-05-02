# Test Docker image
# This image is used to test the harden, install and config scripts.
# 
# Steps:
#   docker build -t test .
#   docker run -it -p 22:22 --name test test
#   passwd
#   ssh root@localhost

FROM ubuntu:focal

RUN DEBIAN_FRONTEND=noninteractive apt update                   && \
    apt install neovim ssh -y									&& \
	echo "PermitRootLogin yes"        >> /etc/ssh/sshd_config   && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

ARG password

RUN usermod --password $(openssl passwd -1 $password) root      && \ 
    TZ=America/New_York date > ~/.docker-date-created

ENTRYPOINT service ssh start && bash
