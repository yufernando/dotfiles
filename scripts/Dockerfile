# Test Docker image
# This image is used to test the harden, install and config scripts.
# 
# Steps:
#   docker build -t test .
#   docker run -it -p 22:22 --name test test
#   passwd
#   ssh root@localhost

FROM ubuntu:focal

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt upgrade -y								&& \
    apt install git make neovim ssh -y							&& \
	echo "PermitRootLogin yes"        >> /etc/ssh/sshd_config   && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

RUN apt install sudo -y 

ARG password

RUN usermod --password $(openssl passwd -1 $password) root      && \ 
    TZ=America/New_York date > /.docker-date-created

ENTRYPOINT service ssh start && bash
