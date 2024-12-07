#!/bin/sh
set -e

echo "Starting WordPress setup..."

while ! nc -z mariadb 3306; do
  echo "Waiting for MariaDB..."
  sleep 1
done

echo "MariaDB is ready. Configuring WordPress..."

if [ ! -f /var/www/html/wp-config.php ]; then
  echo "Downloading WordPress core..."
  wp core download --allow-root

  echo "Creating wp-config.php..."
  wp config create --dbname="$WORDPRESS_DB_NAME" --dbuser="$WORDPRESS_DB_USER" --dbpass="$WORDPRESS_DB_PASSWORD" --dbhost="$WORDPRESS_DB_HOST" --allow-root

  sed -i "41 i define( 'WP_REDIS_HOST', 'redis' );\ndefine( 'WP_REDIS_PORT', '6379' );\n" wp-config.php

  echo "Installing WordPress core..."
  wp core install --url="https://$DOMAIN_NAME" --title="Aitor Uskola Site" --admin_user="$WORDPRESS_ADMIN_USER" --admin_password="$WORDPRESS_ADMIN_PASSWORD" --admin_email="$WORDPRESS_ADMIN_EMAIL" --skip-email --allow-root
  echo "Creating additional user..."
  wp user create "$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" --user_pass="$WORDPRESS_USER_PASSWORD" --role=author --allow-root || echo "Failed to create additional user"

  echo "WordPress configured."
else
  echo "WordPress already configured. Checking for additional user..."
  if ! wp user get "$WORDPRESS_USER" --allow-root > /dev/null 2>&1; then
    echo "Additional user not found. Creating..."
    wp user create "$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" --user_pass="$WORDPRESS_USER_PASSWORD" --role=author --allow-root || echo "Failed to create additional user"
  else
    echo "Additional user already exists."
  fi
fi

echo "Verifying WordPress installation..."
wp core verify-checksums --allow-root
wp user list --allow-root

chown -R nobody:nobody *

wp plugin install redis-cache --activate

echo "Starting PHP-FPM..."
exec php-fpm -F