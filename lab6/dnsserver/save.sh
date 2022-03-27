#!/bin/bash

echo "Saving configuration files....."

if [ -f "/etc/bind/ttm4200.com.zone" ]; then
    cp --backup=t /etc/bind/ttm4200.com.zone /home/ttm4200/work_dir/config_files/etc/bind/ttm4200.com.zone
fi

if [ -f "/etc/bind/rev-ttm4200.com.zone" ]; then
    cp --backup=t /etc/bind/rev-ttm4200.com.zone /home/ttm4200/work_dir/config_files/etc/bind/rev-ttm4200.com.zone
fi
if [ -f "/etc/bind/named.conf.options" ]; then
    cp --backup=t /etc/bind/named.conf.options /home/ttm4200/work_dir/config_files/etc/bind/named.conf.options
fi
if [ -f "/etc/bind/named.conf.local" ]; then
    cp --backup=t /etc/bind/named.conf.local /home/ttm4200/work_dir/config_files/etc/bind/named.conf.local
fi







