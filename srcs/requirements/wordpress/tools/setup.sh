#!/bin/bash
DB_PASSWORD=$(cat "$WORDPRESS_DB_PASSWORD_FILE")
DB_ROOT_PASSWORD=$(cat "$WORDPRESS_DB_ROOT_PASSWORD_FILE")
until mysql -h mariadb -u "$DB_USER" -p"$DB_PASSWORD" -e ";" >/dev/null 2>&1; do
    echo "Waiting for valid DB connection..."
    sleep 2
done

cd /var/www/wordpress

if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
    wp --allow-root core download
    wp config create --allow-root --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASSWORD" --dbhost=mariadb --skip-check --path="/var/www/wordpress"
    wp cli update --allow-root
    wp core install --allow-root --url="$WEBSITE_WP" --title="$DOMAIN_NAME" --admin_user="$DB_ROOT_USER" --admin_password="$DB_ROOT_PASSWORD" --admin_email="$ADMIN_EMAIL" --locale=en_US --skip-email
    wp user create "$DB_USER" "$USER_EMAIL" --role=author --user_pass="$DB_PASSWORD" --allow-root
	#wp theme install blogvi --activate --allow-root
fi

chown -R www-data:www-data /var/www/wordpress


echo "Setup complete"

exec /usr/sbin/php-fpm7.4 -F
