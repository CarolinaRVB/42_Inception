#!/bin/bash

# Initialize database if not done yet
if [ ! -d "/var/lib/mysql/maria_db" ]; then
    INIT_SQL="/init.sql"
    TMP_SQL="/tmp/init_filled.sql"

    # Read secrets
    DB_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")
    DB_ROOT_PASSWORD=$(cat "$MYSQL_ROOT_PASSWORD_FILE")

    # Replace template placeholders on init.sql with the variables
    # and save output on tmp_sql
    export DB_NAME DB_USER DB_PASSWORD DB_ROOT_PASSWORD
    envsubst < "$INIT_SQL" > "$TMP_SQL"

    # start MariaDB and wait for full start
    service mariadb start > /dev/null
    sleep 5
    # execute the temporary file as root to :
    # create database, user and set permissions
    mariadb -u root < "$TMP_SQL"
    #stop mariadb
    service mariadb stop > /dev/null
    # clean files
    rm -f "$INIT_SQL" "$TMP_SQL"
fi

# mysqld_safe helps keep the database running continuously and more stable
exec mysqld_safe > /dev/null;
