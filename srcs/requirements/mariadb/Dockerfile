FROM debian:bullseye

RUN apt update

RUN apt install -y \
    mariadb-server \
    gettext \
    && apt clean

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY ./tools/init.sql.template /init.sql
COPY ./tools/setup.sh /
RUN chmod +x /setup.sh

EXPOSE 3306

ENTRYPOINT [ "./setup.sh" ]