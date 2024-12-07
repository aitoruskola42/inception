#!/bin/sh


adduser -D ${FTP_USER}
echo "${FTP_USER}:${FTP_PASS}" | chpasswd

mkdir -p /var/run/vsftpd/empty
mkdir -p /var/www/html

chown -R ${FTP_USER}:${FTP_USER} /var/www/html
chmod 755 /var/run/vsftpd/empty

addgroup ${FTP_USER} www-data

sed -i "s/^local_root=.*/local_root=\/var\/www\/html/" /etc/vsftpd/vsftpd.conf

exec vsftpd /etc/vsftpd/vsftpd.conf