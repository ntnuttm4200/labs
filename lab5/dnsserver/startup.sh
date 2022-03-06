#!/bin/bash
sh /home/ttm4200/work_dir/restore.sh
ip route del 0/0
ip route add default via 129.100.1.5
macchanger -r eth0
echo "nameserver 129.100.1.2" > /etc/resolv.conf

named-checkconf
systemctl enable bind9
service bind9 restart
source ~/.bashrc

dpkg-reconfigure openssh-server
service ssh restart

su -s /bin/bash ttm4200





