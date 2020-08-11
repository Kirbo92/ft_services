FROM alpine

COPY ./srcs /srcs

RUN apk add mariadb mariadb-client && \
	cp /srcs/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf && \ 
	mkdir -p /run/mysqld/ && \
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql && \
	mariadbd --user=root --bootstrap --verbose=0 --skip-networking=0 --skip-grant-tables=0 < /srcs/data.sql && \
	mariadbd --user=root --bootstrap --verbose=0 --skip-networking=0 --skip-grant-tables=0 < /srcs/wordpress.sql

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT mariadbd-safe --user=root --datadir="/var/lib/mysql"
