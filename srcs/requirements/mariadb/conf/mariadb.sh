#!/bin/bash

# if [ ! -f "/secrets/db_password" ]; then
#     echo $(openssl rand -base64 16) > "/secrets/db_password"
# fi

# Initialize MariaDB
if [ ! -d "/var/lib/mysql/${DB_NAME}" ]; then
  service mariadb start
  sleep 5

  mariadb -u root -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
  mariadb -u root -e "CREATE USER IF NOT EXISTS '${DB_ROOT_USER}'@'%' IDENTIFIED BY '$(cat /run/secrets/db_root_password)';"
  mariadb -u root -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_ROOT_USER}'@'%';"
  
  mariadb -u root -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '$(cat /run/secrets/db_password)';"
  mariadb -u root -e "GRANT SELECT, INSERT, UPDATE ON ${DB_NAME}.* TO '${DB_USER}'@'%';"

  
  mariadb -u root -e "FLUSH PRIVILEGES;"


  service mariadb stop
fi

# Start MariaDB in safe mode
mysqld_safe --bind-address=0.0.0.0 --port=3306 --socket=/run/mysqld/mysqld.sock