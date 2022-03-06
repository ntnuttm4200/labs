#!/bin/bash

echo "Saving config files....."
iptables-save > /etc/iptables.conf
sed -i '/unsupported/d' /etc/iptables.conf
if [ -f "/etc/iptables.conf" ]; then
    cp --backup=t /etc/iptables.conf /home/ttm4200/work_dir/config_files/iptables.conf
fi
vtysh -w
cp --backup=t /etc/frr/frr.conf /home/ttm4200/work_dir/config_files/frr.conf
chmod -R a+rwx /home/ttm4200/work_dir/config_files/
