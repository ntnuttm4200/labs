#!/bin/bash

apt-get update && apt-get install -y \
    nginx \
    php-fpm php-mysql \
    vlc

#nginx
rm /etc/nginx/sites-available/default && rm /etc/nginx/sites-enabled/default
rm -r /var/www/html
#php
sed -ri 's/^;?cgi.fix_pathinfo=.*/cgi.fix_pathinfo=0/' /etc/php/7.4/fpm/php.ini
sed -ri 's/^;?date.timezone\s+.*/date.timezone = Europe\/Oslo/' /etc/php/7.4/fpm/php.ini








