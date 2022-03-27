#!/bin/bash
ip route del 0/0
ip route add default via 10.20.40.100
macchanger -r eth0
if [ -f "/home/ttm4200/work_dir/config_files/nftables.conf" ]; then
    cp /home/ttm4200/work_dir/config_files/nftables.conf  /etc/nftables.conf
    nft -f /etc/nftables.conf
fi
source ~/.bashrc

dpkg-reconfigure openssh-server
service ssh restart

su -s /bin/bash ttm4200





