FROM debian:bullseye

RUN apt update

RUN apt install -y \
    mariadb-server \
    gettext \
    && apt clean 

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/.

#RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld
# RUN mysql_install_db --user=root --basedir=/usr --datadir=/var/lib/mysql


#RUN apt-get update && apt-get install -y gettext

COPY ./tools/init.sql.template /init.sql
COPY ./tools/setup.sh /
RUN chmod +x /setup.sh

#COPY ./tools/init.sql /docker-entrypoint-initdb.d/

EXPOSE 3306

ENTRYPOINT [ "./setup.sh" ]