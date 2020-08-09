FROM alpine

COPY ./srcs /srcs

RUN apk add mariadb mariadb-client && \
	cp /srcs/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf && \ 
	mkdir -p /run/mysqld/ && \
	mysql_install_db --user=root && \
	mysqld --bootstrap < /srcs/data.sql && \
	mysqld --bootstrap < /srcs/wordpress.sql

EXPOSE 3306

ENTRYPOINT mariadbd
