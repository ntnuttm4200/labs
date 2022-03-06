#!/bin/bash

sh /home/ttm4200/work_dir/restore.sh

ip route del 0/0
ip route add default via 129.100.1.5
macchanger -r eth0
echo "nameserver 129.100.1.2" > /etc/resolv.conf

service nginx restart
service php7.2-fpm start

dpkg-reconfigure openssh-server
service ssh restart

source ~/.bashrc
su -s /bin/bash ttm4200
