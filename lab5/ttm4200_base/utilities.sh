#!/bin/bash

apt-get update && apt-get install -y \
    curl wget \
    apt-utils \
    net-tools iputils-ping net-tools iproute2 dnsutils \
    vim nano sudo gnupg \
    isc-dhcp-client \
    openssh-server openbsd-inetd traceroute tmux tcpdump \
    macchanger lsb-release



cp /build/basic.vim /home/ttm4200/.vimrc
cp /build/.bashrc /home/ttm4200/.bashrc
echo 'root:ttm4200' |chpasswd
echo 'ttm4200:ttm4200' |chpasswd

mkdir /var/run/sshd
sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -ri 's/^#?PasswordAuthentication\s+.*/PasswordAuthentication no/' /etc/ssh/sshd_config
#sed -ri 's/^#?Port\s+.*/Port 54200/' /etc/ssh/sshd_config
sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
mkdir /home/ttm4200/.ssh
cat /build/ssh_keys/id_rsa.pub >> /home/ttm4200/.ssh/authorized_keys
cp /build/ssh_keys/ssh_host* /etc/ssh/

