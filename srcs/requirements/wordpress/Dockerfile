FROM alpine:3.20.2

# Instalar dependencias
RUN apk update && apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-json \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-mbstring \
    php82-openssl \
    php82-xml \
    php82-zip \
    php82-phar \
    wget \
    netcat-openbsd

# Descargar e instalar WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# configure PHP-FPM
RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php82/php.ini && \
    sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php82/php-fpm.d/www.conf

RUN ln -s /usr/bin/php82 /usr/bin/php && \
    ln -s /usr/sbin/php-fpm82 /usr/sbin/php-fpm
    
ENV PATH="/usr/bin:${PATH}"

RUN mkdir -p /var/www/html

COPY tools/start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /var/www/html

EXPOSE 9000

CMD ["/start.sh"]