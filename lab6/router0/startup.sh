#!/bin/bash
sh /home/ttm4200/work_dir/restore.sh
VAR=$(ip a | grep 10.20.30.100 | sed 's/.*\(eth*\)/\1/'); ip link set $VAR down; ip link set $VAR name ether0; ip link set ether0 up
VAR=$(ip a | grep 129.168.1.2 | sed 's/.*\(eth*\)/\1/'); ip link set $VAR down; ip link set $VAR name ether1; ip link set ether1 up

macchanger -r ether0

ip route del 0/0

if [ -f "/home/ttm4200/work_dir/config_files/frr.conf" ]; then
    cp /home/ttm4200/work_dir/config_files/frr.conf /etc/frr/frr.conf
fi
service frr restart

if [ -f "/home/ttm4200/work_dir/config_files/nftables.conf" ]; then
    cp /home/ttm4200/work_dir/config_files/nftables.conf  /etc/nftables.conf
    nft -f /etc/nftables.conf
fi
if [ -f "/home/ttm4200/work_dir/config_files/wg0.conf" ]; then
    cp /home/ttm4200/work_dir/config_files/wg0.conf /etc/wireguard/wg0.conf
    wg-quick up /etc/wireguard/wg0.conf
fi
source ~/.bashrc

dpkg-reconfigure openssh-server
service ssh restart

su -s /bin/bash ttm4200
