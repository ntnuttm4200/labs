#!/bin/bash

echo "Saving config files....."
if [ -f "/etc/wireguard/wg0.conf" ]; then
    cp /etc/wireguard/wg0.conf /home/ttm4200/work_dir/config_files/wg0.conf
fi
chmod -R a+rwx /home/ttm4200/work_dir/config_files/
