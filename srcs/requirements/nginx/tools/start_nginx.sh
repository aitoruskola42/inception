#!/bin/sh

echo "Starting Nginx startup script..."

if [ ! -d "/etc/nginx/ssl" ]; then
    echo "Creating SSL directory..."
    mkdir -p /etc/nginx/ssl
fi

if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
    echo "Generating SSL certificate..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/C=ES/ST=Vizcaya/L=Bilbao/O=42/OU=42Urduliz/CN=${DOMAIN_NAME}" || echo "Failed to generate certificate"

    if [ -f /etc/nginx/ssl/nginx.crt ] && [ -f /etc/nginx/ssl/nginx.key ]; then
        echo "SSL certificate and key generated successfully."
    else
        echo "Failed to generate SSL certificate and key."
    fi
    
    chown -R nginx:nginx /etc/nginx/ssl || echo "Failed to change ownership of SSL directory"
    chmod 600 /etc/nginx/ssl/nginx.key || echo "Failed to set permissions on nginx.key"
    chmod 644 /etc/nginx/ssl/nginx.crt || echo "Failed to set permissions on nginx.crt"
    
    echo "Permissions for SSL files set."
else
    echo "SSL certificate already exists."
fi

# list ssl directory content
echo "Contents of /etc/nginx/ssl:"
ls -la /etc/nginx/ssl

echo "Attempting to resolve WordPress hostname..."
getent hosts wordpress || echo "Failed to resolve WordPress"

echo "Waiting for WordPress to become available..."
until nc -z wordpress 9000; do
    echo "WordPress is not yet available. Retrying in 5 seconds..."
    sleep 5
done

echo "WordPress is now available. Starting Nginx..."

exec nginx -g 'daemon off;'