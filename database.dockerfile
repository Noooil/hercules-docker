FROM mariadb:latest

ENV MYSQL_DATABASE=ragnarok
ENV MYSQL_ALLOW_EMPTY_PASSWORD=yes

COPY main.sql /docker-entrypoint-initdb.d
COPY logs.sql /docker-entrypoint-initdb.d
COPY mariadb.cnf /etc/mysql/mariadb.conf.d