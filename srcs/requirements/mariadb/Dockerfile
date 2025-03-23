FROM debian:bullseye

RUN apt update

RUN apt install -y \
    mariadb-server \
    && apt clean 

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/.

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

COPY ./tools/init.sql /

RUN chmod +x /init.sql

COPY ./tools/setup.sh /
RUN chmod +x /setup.sh

#COPY ./tools/init.sql /docker-entrypoint-initdb.d/

EXPOSE 3306

ENTRYPOINT [ "./setup.sh" ]