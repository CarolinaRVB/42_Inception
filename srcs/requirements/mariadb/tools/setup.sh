#!/bin/bash

# Initialize database if not done yet
if [ ! -d "/var/lib/mysql/maria_db" ]; then
    INIT_SQL="/init.sql"
    TMP_SQL="/tmp/init_filled.sql"

    # Read secrets
    DB_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")
    DB_ROOT_PASSWORD=$(cat "$MYSQL_ROOT_PASSWORD_FILE")

    # Replace template placeholders
    export DB_NAME DB_USER DB_ROOT_USER DB_PASSWORD DB_ROOT_PASSWORD
    envsubst < "$INIT_SQL" > "$TMP_SQL"

    service mariadb start > /dev/null
    sleep 5
    mariadb -u root < "$TMP_SQL"
    service mariadb stop > /dev/null
    rm -f "$INIT_SQL" "$TMP_SQL"
fi

# Start the MariaDB server in foreground
exec mysqld --bind-address=0.0.0.0 --port=3306 --socket=/run/mysqld/mysqld.sock > /dev/null

