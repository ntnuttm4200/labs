#!/bin/bash
VAR=$(ip a | grep 129.168.1.3/29 | sed 's/.*\(eth*\)/\1/'); ip link set $VAR down; ip link set $VAR name ether0; ip link set ether0 up
VAR=$(ip a | grep 129.168.1.11/29 | sed 's/.*\(eth*\)/\1/'); ip link set $VAR down; ip link set $VAR name ether1; ip link set ether1 up
VAR=$(ip a | grep 129.168.1.19/29 | sed 's/.*\(eth*\)/\1/'); ip link set $VAR down; ip link set $VAR name ether2; ip link set ether2 up

# ip route add default via 129.168.1.26
# ip route add 129.100.1.0/24 via 129.168.1.2

macchanger -r eth0
echo "nameserver 129.100.1.2" > /etc/resolv.conf
if [ -f "/home/ttm4200/work_dir/config_files/frr.conf" ]; then
     cp /home/ttm4200/work_dir/config_files/frr.conf  /etc/frr/frr.conf
fi
service frr restart
source ~/.bashrc

dpkg-reconfigure openssh-server
service ssh restart

#cp /home/ttm4200/work_dir/config_files/quagga/* /etc/quagga/

#sh /etc/quagga/init_conf.sh

su -s /bin/bash ttm4200





