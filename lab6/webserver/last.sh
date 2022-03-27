#!/bin/bash

apt-get update && apt-get install -y \
    php-imap php-mbstring php7.2-imap php7.2-mbstring \
    postfix postfix-mysql sasl2-bin \
    dovecot-imapd dovecot-mysql dovecot-managesieved mailutils tree \
    phpmyadmin php-net-ldap3 php-intl\
    net-tools iputils-ping net-tools iproute2 dnsutils telnet \
    expect \
    wget \
    apt-utils \
    nginx \
    mysql-server \
    php-fpm php-mysql \
    systemd \
    vim nano sudo man \
    openssh-server openbsd-inetd tshark tmux


mysql_root=ttm4200_magic_word_root

find /var/lib/mysql/mysql -exec touch -c -a {} + && service mysql start && mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${mysql_root}';"
mysql --password=$mysql_root < /build/config_files/mysql_databases/dump.sql

cp /build/config_files/etc/php/7.2/fpm/php.ini /etc/php/7.2/fpm/php.ini
#default site
cp -Tr /build/config_files/var/www/ttm4200/ /var/www/ttm4200/

cp /build/config_files/etc/nginx/sites_available/default /etc/nginx/sites-available/default

if [ -f "/build/config_files/etc/nginx/sites-available/teamsite" ]; then
    cp /build/config_files/etc/nginx/sites_available/teamsite /etc/nginx/sites-available/teamsite  
    ln -s /etc/nginx/sites-available/teamsite /etc/nginx/sites-enabled/teamsite
fi

if [ -d "/home/config_files/var/www/teamsite/" ]; then
    mkdir /var/www/teamsite/
    cp -Tr  --backup=t /home/config_files/var/www/teamsite/  /var/www/teamsite/  
fi

#postfixadmin
#********************
cp -Tr /build/config_files/opt/postfixadmin/ /opt/postfixadmin/
if [ -f "/build/config_files/etc/nginx/sites_available/postfixadmin" ]; then
    cp /build/config_files/etc/nginx/sites_available/postfixadmin /etc/nginx/sites-available/postfixadmin
    ln -s /etc/nginx/sites-available/postfixadmin /etc/nginx/sites-enabled/
fi
ln -s /opt/postfixadmin/public/ /var/www/postfixadmin

#postfixadmin requires permission to a sub-folder named templates_c 
chown -R www-data:www-data /opt/postfixadmin/templates_c
#postfix
cp /build/config_files/etc/default/saslauthd /etc/default/saslauthd
service saslauthd restart
groupadd -g 5000 vmail && mkdir -p /var/mail/vmail
useradd -u 5000 vmail -g vmail -s /usr/sbin/nologin -d /var/mail/vmail
chown -R vmail:vmail /var/mail/vmail

#Create the configuration files for the database
cp -Tr /build/config_files/etc/postfix/sql/ /etc/postfix/sql/
cp /build/config_files/etc/postfix/main.cf /etc/postfix/main.cf && cp /build/config_files/etc/postfix/master.cf /etc/postfix/master.cf

postconf -e virtual_mailbox_domains=mysql:/etc/postfix/sql/mysql_virtual_domains_maps.cf
postconf -e virtual_mailbox_maps=mysql:/etc/postfix/sql/mysql_virtual_mailbox_maps.cf
postconf -e virtual_alias_maps=mysql:/etc/postfix/sql/mysql_virtual_alias_maps.cf
chgrp postfix /etc/postfix/sql/mysql_*.cf

#copying created mails

if [ -d "/build/config_files/var/mail/vmail/" ]; then
	cp -Tr /build/config_files/var/mail/vmail/ /var/mail/vmail
fi


# dovecot
cp -Tr /build/config_files/etc/dovecot/conf.d/ /etc/dovecot/conf.d/
cp  /build/config_files/etc/dovecot/dovecot-sql.conf.ext /etc/dovecot/dovecot-sql.conf.ext
chgrp vmail /etc/dovecot/dovecot.conf

#********************
 #phpmyadmin

cp /build/config_files/etc/nginx/sites_available/phpmyadmin /etc/nginx/sites-available/phpmyadmin
ln -s /etc/nginx/sites-available/phpmyadmin /etc/nginx/sites-enabled/

cp /build/config_files/etc/phpmyadmin/config.inc.php /etc/phpmyadmin/config.inc.php 
cp /build/config_files/usr/share/phpmyadmin/libraries/sql.lib.php /usr/share/phpmyadmin/libraries/sql.lib.php
ln -s /usr/share/phpmyadmin /var/www/phpmyadmin



#********************
 #roundcubemail
if [ -f "/build/config_files/etc/nginx/sites_available/webmail" ]; then
    cp /build/config_files/etc/nginx/sites_available/webmail /etc/nginx/sites-available/webmail
    ln -s /etc/nginx/sites-available/webmail /etc/nginx/sites-enabled/
fi

cp -Tr /build/config_files/var/www/webmail/ /var/www/webmail/

chown -R www-data:www-data /var/www/webmail/
chmod 755 /var/www/webmail/temp/ /var/www/webmail/logs/

mkdir /var/run/sshd
echo 'root:root' |chpasswd
sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config




