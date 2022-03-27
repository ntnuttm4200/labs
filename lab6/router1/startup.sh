#!/bin/bash
VAR=$(ip a | grep 10.20.40.100 | sed 's/.*\(eth*\)/\1/'); ip link set $VAR down; ip link set $VAR name ether0; ip link set ether0 up
VAR=$(ip a | grep 129.168.1.10/29 | sed 's/.*\(eth*\)/\1/'); ip link set $VAR down; ip link set $VAR name ether1; ip link set ether1 up

ip route del 0/0

macchanger -r ether0
if [ -f "/home/ttm4200/work_dir/config_files/frr.conf" ]; then
     cp /home/ttm4200/work_dir/config_files/frr.conf  /etc/frr/frr.conf
fi
service frr restart
if [ -f "/home/ttm4200/work_dir/config_files/nftables.conf"  ]; then
    cp /home/ttm4200/work_dir/config_files/nftables.conf  /etc/nftables.conf
    nft -f /etc/nftables.conf
fi
source ~/.bashrc

dpkg-reconfigure openssh-server
service ssh restart

su -s /bin/bash ttm4200





