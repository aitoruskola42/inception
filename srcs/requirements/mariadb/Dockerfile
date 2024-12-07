FROM alpine:3.20.2

RUN apk update && apk add --no-cache mariadb mariadb-client

COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

COPY conf/my.cnf /etc/my.cnf.d/mariadb-server.cnf

RUN mkdir -p /var/lib/mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

EXPOSE 3306

CMD ["/init.sh"]
