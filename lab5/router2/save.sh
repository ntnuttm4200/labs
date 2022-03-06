#!/bin/bash

echo "Saving config files....."

cp --backup=t /etc/dhcp/dhcpd.conf /home/ttm4200/work_dir/config_files/dhcpd.conf
cp --backup=t /etc/default/isc-dhcp-server /home/ttm4200/work_dir/config_files/isc-dhcp-server

#echo "Saving iptables....."
iptables-save > /etc/iptables.conf
sed -i '/unsupported/d' /etc/iptables.conf

if [ -f "/etc/iptables.conf" ]; then
    cp --backup=t /etc/iptables.conf /home/ttm4200/work_dir/config_files/iptables.conf
fi


vtysh -w
cp --backup=t /etc/frr/frr.conf /home/ttm4200/work_dir/config_files/frr.conf

chmod -R a+rwx /home/ttm4200/work_dir/config_files/

