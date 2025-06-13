#!/bin/bash
DB_PASSWORD=$(cat "$WORDPRESS_DB_PASSWORD_FILE")
ADMIN_PASSWORD=$(cat "$WORDPRESS_ADMIN_PASSWORD_FILE")
TEST_PASSWORD=$(cat "$WORDPRESS_TEST_PASSWORD_FILE")

# waiting on database connection
until mysql -h mariadb -u "$DB_USER" -p"$DB_PASSWORD" -e ";" >/dev/null 2>&1; do
    echo "Waiting for valid DB connection..."
    sleep 2
done

cd /var/www/wordpress

# setup of the wordpress site, adds admin user/credentials as well as a test_user as a subscriber
if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
    wp --allow-root core download
    wp config create --allow-root --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASSWORD" --dbhost=mariadb --skip-check --path="/var/www/wordpress"
    wp cli update --allow-root
    wp core install --allow-root --url="$WEBSITE_WP" --title="$DOMAIN_NAME" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASSWORD" --admin_email="$ADMIN_EMAIL" --locale=en_US --skip-email
    wp user create "$TEST_USER" "test_user@gmail.com" --role=subscriber --user_pass="$TEST_PASSWORD" --allow-root
	wp theme install geologist --activate --allow-root
fi

#Ensures WordPress files are owned by the web server user (www-data), required for proper access and operation
chown -R www-data:www-data /var/www/wordpress


echo "Setup complete"
exec /usr/sbin/php-fpm7.4 -F
