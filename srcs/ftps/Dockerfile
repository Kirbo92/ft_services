FROM alpine

ARG IP

COPY ./srcs /srcs/

RUN apk update && \
	apk add vsftpd openssl && \
	echo "root:root" | chpasswd && \
	openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 -subj "/C=SP/ST=Spain/L=Madrid/O=42/CN=127.0.0.1" \
	-keyout /etc/ssl/private/migferna.key \
	-out /etc/ssl/certs/migferna.crt && \
	chmod +x /srcs/run.sh

EXPOSE 21 30021

ENTRYPOINT ["/srcs/run.sh"] 
