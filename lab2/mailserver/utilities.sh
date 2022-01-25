#!/bin/bash
#Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
sed -i "s/^exit 101$/exit 0/" /usr/sbin/policy-rc.d
apt-get update && apt-get install -y \
    mysql-server \
    php-imap php-mbstring php7.2-imap php7.2-mbstring \
    postfix postfix-mysql sasl2-bin \
    dovecot-imapd dovecot-mysql dovecot-managesieved \
    mailutils tree \
    phpmyadmin php-net-ldap3 php-intl

wget -P /opt https://github.com/postfixadmin/postfixadmin/archive/postfixadmin-3.2.tar.gz
cd /opt && tar xvf postfixadmin-3.2.tar.gz
mv postfixadmin-postfixadmin-3.2/ postfixadmin && rm postfixadmin-3.2.tar.gz
#ln -s /opt/postfixadmin/public/ /var/www/ttm4200/pfa
#mysql
mysql_root_password=ttm4200
postfix_db_password=ttm4200
roundcube_db_password=ttm4200
phpmyadmin_db_password=ttm4200
find /var/lib/mysql/mysql -exec touch -c -a {} + && mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${mysql_root_password}';"
mysql -u root -p${mysql_root_password} <<EOF
CREATE DATABASE postfix;
CREATE USER 'postfix'@'localhost' IDENTIFIED BY '${postfix_db_password}';
GRANT ALL PRIVILEGES ON postfix.* TO 'postfix'@'localhost';
FLUSH PRIVILEGES;
exit
EOF

cat >/opt/postfixadmin/config.local.php <<EOL
<?php
\$CONF['database_type'] = 'mysqli';
\$CONF['database_user'] = 'postfix';
\$CONF['database_password'] = '${postfix_db_password}';
\$CONF['database_name'] = 'postfix';
\$CONF['configured'] = true;
\$CONF['setup_password'] = '6d40029eeaed0de4cfe4bf2f223609ba:5ed68e7927f9889f03154b03d1d77434be353222';
\$CONF['emailcheck_resolve_domain']='NO';
?>
EOL
mkdir /opt/postfixadmin/templates_c && chmod 755 -R /opt/postfixadmin/templates_c
chown -R www-data:www-data /opt/postfixadmin/templates_c

sed -ri 's/^START=.*/START=yes/' /etc/default/saslauthd
groupadd -g 5000 vmail && mkdir -p /var/mail/vmail
useradd -u 5000 vmail -g vmail -s /usr/sbin/nologin -d /var/mail/vmail
chown -R vmail:vmail /var/mail/vmail
mkdir -p /etc/postfix/sql

cat >/etc/postfix/sql/mysql_virtual_domains_maps.cf <<EOL
user = postfix
password = ${postfix_db_password}
hosts = 127.0.0.1
dbname = postfix
query = SELECT domain FROM domain WHERE domain='%s' AND active = '1'
EOL
postconf -e virtual_mailbox_domains=mysql:/etc/postfix/sql/mysql_virtual_domains_maps.cf

cat >/etc/postfix/sql/mysql_virtual_mailbox_maps.cf <<EOL
user = postfix
password = ${postfix_db_password}
hosts = 127.0.0.1
dbname = postfix
query = SELECT maildir FROM mailbox WHERE username='%s' AND active = '1'
EOL
postconf -e virtual_mailbox_maps=mysql:/etc/postfix/sql/mysql_virtual_mailbox_maps.cf

cat >/etc/postfix/sql/mysql_virtual_alias_maps.cf <<EOL
user = postfix
password = ${postfix_db_password}
hosts = 127.0.0.1
dbname = postfix
query = SELECT goto FROM alias WHERE address='%s' AND active = '1'
EOL
postconf -e virtual_alias_maps=mysql:/etc/postfix/sql/mysql_virtual_alias_maps.cf
chgrp postfix /etc/postfix/sql/mysql_*.cf

cat >> /etc/postfix/main.cf <<EOL
smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_auth_enable = yes
smtpd_sasl_security_options = noanonymous
smtpd_sasl_local_domain = \$myhostname
smtpd_tls_security_level = may
smtpd_tls_auth_only = no
smtpd_recipient_restrictions = permit_mynetworks permit_sasl_authenticated reject_unauth_destination
EOL
cat >> /etc/postfix/master.cf <<EOL
submission inet n       -       y       -       -       smtpd
   -o syslog_name=postfix/submission
   -o smtpd_tls_security_level=encrypt
   -o smtpd_sasl_auth_enable=yes
   -o smtpd_client_restrictions=permit_sasl_authenticated,reject
   -o milter_macro_daemon_name=ORIGINATING
 smtps     inet  n       -       y       -       -       smtpd
   -o syslog_name=postfix/smtps
   -o smtpd_tls_wrappermode=yes
   -o smtpd_sasl_auth_enable=yes
   -o smtpd_client_restrictions=permit_sasl_authenticated,reject
   -o milter_macro_daemon_name=ORIGINATING
EOL

#Configuration of dovecot
sed -ri 's/^auth_mechanisms\s+.*/auth_mechanisms = plain login/' /etc/dovecot/conf.d/10-auth.conf
sed -ri 's/^!include auth-system.conf.ext/#!include auth-system.conf.ext/' /etc/dovecot/conf.d/10-auth.conf
sed -ri 's/^#!include auth-sql.conf.ext/!include auth-sql.conf.ext/' /etc/dovecot/conf.d/10-auth.conf
#This made me lose a whole afternooon Allow insecure IMAP/SMTP connections without STARTTLS
cat >> /etc/dovecot/conf.d/10-auth.conf <<EOL
disable_plaintext_auth=no
ssl=no
EOL

cat > /etc/dovecot/conf.d/auth-sql.conf.ext <<EOL
passdb {
  driver = sql
  args = /etc/dovecot/dovecot-sql.conf.ext
}
userdb {
  driver = static
  args = uid=vmail gid=vmail home=/var/mail/vmail/%d/%n
}
EOL
cat >> /etc/dovecot/dovecot-sql.conf.ext <<EOL
driver = mysql
connect = host=127.0.0.1 dbname=postfix user=postfix password=${postfix_db_password}
password_query = SELECT username,domain,password FROM mailbox WHERE username='%u';
default_pass_scheme = MD5-CRYPT
EOL
sed -ri 's/^mail_location\s+.*/mail_location = maildir:\/var\/mail\/vmail\/%d\/%n\/Maildir/' /etc/dovecot/conf.d/10-mail.conf
cat >> /etc/dovecot/conf.d/10-master.conf <<EOL
service auth {
  unix_listener auth-userdb {
    mode = 0600
    user = vmail
  }

  unix_listener /var/spool/postfix/private/auth {
    mode = 0660
    user = postfix
    group = postfix
  }

  user = dovecot
}
EOL
sed -ri 's/#mail_plugins\s+.*/mail_plugins = \$mail_plugins sieve/' /etc/dovecot/conf.d/15-lda.conf
chgrp vmail /etc/dovecot/dovecot.conf

#Integrate dovecot to postfix
cat >> /etc/postfix/master.cf <<EOL
dovecot   unix  -       n       n       -       -       pipe
  flags=DRhu user=vmail:vmail argv=/usr/lib/dovecot/deliver -f \${sender} -d \${user}@\${nexthop}
EOL
cat >> /etc/postfix/main.cf <<EOL
virtual_transport = dovecot
dovecot_destination_recipient_limit = 1
EOL

#RoundCube
mkdir /var/www/ttm4200 && cd /var/www/ttm4200 
wget https://github.com/roundcube/roundcubemail/releases/download/1.3.6/roundcubemail-1.3.6-complete.tar.gz
tar xvf roundcubemail-1.3.6-complete.tar.gz
mv roundcubemail-1.3.6 webmail
rm roundcubemail-1.3.6-complete.tar.gz && cd webmail

mysql -u root -p${mysql_root_password} <<EOF
CREATE DATABASE roundcubedb;
CREATE USER 'roundcube'@'localhost' IDENTIFIED BY '${roundcube_db_password}';
GRANT ALL PRIVILEGES ON roundcubedb.* TO 'roundcube'@'localhost';
FLUSH PRIVILEGES;
exit
EOF
mysql -u root -p${mysql_root_password} roundcubedb < /var/www/ttm4200/webmail/SQL/mysql.initial.sql
# Local configuration for Roundcube Webmail
cat >> /var/www/ttm4200/webmail/config/config.inc.php << EOF
<?php 
\$config['db_dsnw'] = 'mysql://roundcube:${roundcube_db_password}@localhost/roundcubedb';
\$config['default_host'] = 'localhost';
\$config['des_key'] = 'tKNjKFcyY85ixi7xO9FIAw7K';
\$config['support_url'] = '';
\$config['plugins'] = array();
EOF
#config.inc.php

#phpmyadmin (remove it)
mysql -u root -p${mysql_root_password} <<EOF
CREATE DATABASE phpmyadmin;
CREATE USER 'pma'@'localhost' IDENTIFIED BY '${phpmyadmin_db_password}';
GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'pma'@'localhost';
FLUSH PRIVILEGES;
exit
EOF
mysql -u root -p${mysql_root_password} phpmyadmin < /usr/share/phpmyadmin/sql/create_tables.sql
cat >> /etc/phpmyadmin/config.inc.php <<EOF
\$cfg['Servers'][1]['pmadb'] = 'phpmyadmin';
\$cfg['Servers'][1]['controluser'] = 'pma';
\$cfg['Servers'][1]['controlpass'] = '${phpmyadmin_db_password}';
EOF
sudo sed -i "s/|\s*\((count(\$analyzed_sql_results\['select_expr'\]\)/| (\1)/g" /usr/share/phpmyadmin/libraries/sql.lib.php
