#!/bin/bash

echo "Saving configuration files....."


if [ -f "/etc/nginx/sites-available/ttm4200" ]; then
    echo "Saving /etc/nginx/sites-available/ttm4200"
    cp /etc/nginx/sites-available/ttm4200 /home/ttm4200/work_dir/config_files/etc/nginx/sites-available/ttm4200
fi

if [ -f "/etc/nginx/sites-available/teamsite" ]; then
    echo "Saving /etc/nginx/sites-available/teamsite"
    cp /etc/nginx/sites-available/teamsite /home/ttm4200/work_dir/config_files/etc/nginx/sites-available/teamsite
fi

# if [ -d "/var/www/" ]; then
#     echo "Saving /var/www/"
#     cp -Tr /var/www/ /home/ttm4200/work_dir/config_files/var/www/
# fi


 if [ -f "/etc/ssl/private/ttm4200-selfsigned.key" ]; then
     echo "Saving /etc/ssl/private/ttm4200-selfsigned.key"
     cp --backup=t /etc/ssl/private/ttm4200-selfsigned.key /home/ttm4200/work_dir/config_files/etc/ssl/private/ttm4200-selfsigned.key
 fi

 if [ -f "/etc/ssl/certs/ttm4200-selfsigned.crt" ]; then
     echo "Saving /etc/ssl/certs/ttm4200-selfsigned.crt"
     cp --backup=t /etc/ssl/certs/ttm4200-selfsigned.crt /home/ttm4200/work_dir/config_files/etc/ssl/certs/ttm4200-selfsigned.crt
 fi

 if [ -f "/etc/ssl/certs/dhparam.pem" ]; then
     echo "Saving /etc/ssl/certs/dhparam.pem"
     cp --backup=t /etc/ssl/certs/dhparam.pem /home/ttm4200/work_dir/config_files/etc/ssl/certs/dhparam.pem
 fi
 chmod -R a+rwx /home/ttm4200/work_dir/config_files/
