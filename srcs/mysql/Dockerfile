FROM alpine

COPY ./srcs /srcs

RUN apk add mariadb mariadb-client && \
	cp /srcs/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf && \ 
	mkdir -p /run/mysqld/
EXPOSE 3306

ENTRYPOINT 	mariadb-install-db --user=root --datadir="/var/lib/mysql" && \
 			mariadbd-safe --user=root --datadir="/var/lib/mysql/"
