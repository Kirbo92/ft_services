FROM alpine

COPY ./srcs /srcs

RUN apk add mariadb mariadb-client && \
	cp /srcs/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf && \
	mkdir -p /run/mariadb && \
 	/usr/bin/mariadb-install-db --user=root --datadir="/var/lib/mysql" && \
	/usr/bin/mysqld --user=root --bootstrap < /srcs/data.sql

EXPOSE 3306
CMD	/usr/bin/mysqld_safe --datadir="/var/lib/mysql"
	
