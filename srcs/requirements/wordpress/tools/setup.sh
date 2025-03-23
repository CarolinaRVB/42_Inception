#!/bin/bash

sleep 4


chown -R www-data:www-data /var/www/wordpress
chmod -R 755 /var/www/wordpress

cd /var/www/wordpress

if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
    wp --allow-root core download
    
    # Read password from the Docker secret file
    DB_PASSWORD=$(cat /run/secrets/db_password)
    DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

    wp config create --path="/var/www/wordpress" --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASSWORD" --dbhost=mariadb:3306 --allow-root
    wp cli update --allow-root
    wp core install --allow-root --url="$WEBSITE_WP" --title="$DOMAIN_NAME" --admin_user="$DB_ROOT_USER" --admin_password="$DB_ROOT_PASSWORD" --admin_email="$ADMIN_EMAIL"
    
    wp user create "$DB_USER" "$USER_EMAIL" --role=author --user_pass="$DB_PASSWORD" --allow-root
    wp theme install twentytwentyfour --activate --allow-root

fi


echo "Setup complete"

exec /usr/sbin/php-fpm7.4 -F
