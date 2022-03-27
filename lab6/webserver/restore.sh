#!/bin/bash


if [ -f "/home/ttm4200/work_dir/config_files/etc/nginx/sites-available/ttm4200" ]; then
    echo "Restoring /etc/nginx/sites-available/ttm4200"
    cp /home/ttm4200/work_dir/config_files/etc/nginx/sites-available/ttm4200 /etc/nginx/sites-available/ttm4200
    ln -s /etc/nginx/sites-available/ttm4200 /etc/nginx/sites-enabled/ttm4200
fi
if [ -f "/home/ttm4200/work_dir/config_files/etc/nginx/sites-available/teamsite" ]; then
    echo "Restoring /etc/nginx/sites-available/teamsite"
    cp /home/ttm4200/work_dir/config_files/etc/nginx/sites-available/teamsite /etc/nginx/sites-available/teamsite
    ln -s /etc/nginx/sites-available/teamsite /etc/nginx/sites-enabled/teamsite
fi

if [ -d "/home/ttm4200/work_dir/config_files/var/www/" ]; then
    #mkdir /var/www/
    cp -Tr /home/ttm4200/work_dir/config_files/var/www/  /var/www/
    chmod -R go+xr /var/www/
fi

 if [ -f "/home/ttm4200/work_dir/config_files/etc/ssl/private/ttm4200-selfsigned.key" ]; then
     echo "Restoring /etc/ssl/private/ttm4200-selfsigned.key"
     cp --backup=t /home/ttm4200/work_dir/config_files/etc/ssl/private/ttm4200-selfsigned.key /etc/ssl/private/ttm4200-selfsigned.key
     chmod -R go+xr /etc/ssl/
 fi
 
 if [ -f "/home/ttm4200/work_dir/config_files/etc/ssl/certs/ttm4200-selfsigned.crt" ]; then
     echo "Restoring /etc/ssl/certs/ttm4200-selfsigned.crt"
     cp --backup=t /home/ttm4200/work_dir/config_files/etc/ssl/certs/ttm4200-selfsigned.crt /etc/ssl/certs/ttm4200-selfsigned.crt
     chmod -R go+xr /etc/ssl/
 fi
 
 if [ -f "/home/ttm4200/work_dir/config_files/etc/ssl/certs/dhparam.pem" ]; then
     echo "Restoring /etc/ssl/certs/dhparam.pem"
     cp --backup=t /home/ttm4200/work_dir/config_files/etc/ssl/certs/dhparam.pem /etc/ssl/certs/dhparam.pem
     chmod -R go+xr /etc/ssl/
fi

