FROM alpine

COPY ./srcs/ /srcs

RUN apk update && \
    apk add nginx openssl openssh && \
	cp /srcs/default.conf /etc/nginx/conf.d/ && \
	ssh-keygen -A && \
	echo "root:root" | chpasswd && \
	mkdir -p /run/nginx && \
	openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 -subj "/C=SP/ST=Spain/L=Madrid/O=42/CN=127.0.0.1" \
	-keyout /etc/ssl/private/migferna.key \
	-out /etc/ssl/certs/migferna.crt

EXPOSE 80 443 22

WORKDIR /etc/init.d/

ENTRYPOINT /usr/sbin/sshd -f /srcs/sshd_config; nginx -g 'daemon off;'

