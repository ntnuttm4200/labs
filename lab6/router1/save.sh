#!/bin/bash

echo "Saving config files....."
# saving frr
vtysh -w
cp --backup=t /etc/frr/frr.conf /home/ttm4200/work_dir/config_files/frr.conf
# saving nft
nft list ruleset > /etc/nftables.conf
if [ -f "/etc/nftables.conf" ]; then
    cp --backup=t /etc/nftables.conf /home/ttm4200/work_dir/config_files/nftables.conf
fi
chmod -R a+rwx /home/ttm4200/work_dir/config_files/
