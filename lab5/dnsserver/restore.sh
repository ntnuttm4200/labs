#!/bin/bash

echo "Restoring configuration files....."
if [ -f "/home/ttm4200/work_dir/config_files/etc/bind/ttm4200.com.zone" ]; then
    cp --backup=t /home/ttm4200/work_dir/config_files/etc/bind/ttm4200.com.zone /etc/bind/ttm4200.com.zone
fi
if [ -f "/home/ttm4200/work_dir/config_files/etc/bind/rev-ttm4200.com.zone" ]; then
    cp --backup=t /home/ttm4200/work_dir/config_files/etc/bind/rev-ttm4200.com.zone /etc/bind/rev-ttm4200.com.zone
fi
if [ -f "/home/ttm4200/work_dir/config_files/etc/bind/named.conf.options" ]; then
    cp --backup=t /home/ttm4200/work_dir/config_files/etc/bind/named.conf.options /etc/bind/named.conf.options
fi
if [ -f "/home/ttm4200/work_dir/config_files/etc/bind/named.conf.local" ]; then
    cp --backup=t /home/ttm4200/work_dir/config_files/etc/bind/named.conf.local /etc/bind/named.conf.local
fi
