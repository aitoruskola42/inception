FROM alpine:3.20.2

RUN apk update && apk add --no-cache vsftpd

COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN mkdir -p /var/run/vsftpd/empty /var/www/html

COPY tools/start_ftp.sh /start_ftp.sh
RUN chmod +x /start_ftp.sh

EXPOSE 21 21000-21010

CMD ["/start_ftp.sh"]