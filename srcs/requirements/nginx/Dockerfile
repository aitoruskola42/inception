FROM alpine:3.20.2

# Install NGINX and OpenSSL
RUN apk update && apk add --no-cache nginx openssl

RUN mkdir -p /etc/nginx/ssl

# make SSL local certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=ES/ST=Vizcaya/L=Bilbao/O=42/OU=42Urduliz/CN=${DOMAIN_NAME}"

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

COPY tools/start_nginx.sh /start_nginx.sh
RUN echo "<?php phpinfo(); ?>" > /info.php
RUN chmod +x start_nginx.sh
CMD ["/start_nginx.sh"]


