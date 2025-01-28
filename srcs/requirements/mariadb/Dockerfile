FROM debian:bullseye

RUN apt update

RUN apt install -y \
    mariadb-server \
    && apt clean 

#This file should define secure settings like: bind address, SSL etc
COPY ./conf/mariadb.sh /etc/mariadb/mariadb.sh

#Copy entrypoint script to initialize Mariadb
#The entrypoint script will configure the MariaDB server on container startup. 
#It will initialize the database, create a user, and set secure permissions.
COPY ./conf/mariadb.sh /

EXPOSE 3306

RUN chmod +x /mariadb.sh

ENTRYPOINT [ "./mariadb.sh" ]