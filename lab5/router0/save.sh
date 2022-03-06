#!/bin/bash

echo "Saving config files....."

vtysh -w
cp --backup=t /etc/frr/frr.conf /home/ttm4200/work_dir/config_files/frr.conf
chmod -R a+rwx /home/ttm4200/work_dir/config_files/
