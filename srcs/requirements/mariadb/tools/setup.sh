#! /usr/bin/env bash

INIT_SQL="/init.sql"

if [ ! -d "/var/lib/mysql/maria_db" ]; then
    service mariadb start
    sleep 5
    if [ -f "$INIT_SQL" ]; then
        mariadb -u root < "$INIT_SQL"
        rm -f "$INIT_SQL"
    fi
    service mariadb stop
fi



mysqld --bind-address=0.0.0.0 --port=3306 --socket=/run/mysqld/mysqld.sock
