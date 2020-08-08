FROM alpine


COPY ./srcs /srcs/

RUN apk update && \
	apk add vsftpd openssl && \
	echo "root:root" | chpasswd && \
	openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 -subj "/C=SP/ST=Spain/L=Madrid/O=42/CN=127.0.0.1" \
	-keyout /etc/ssl/private/migferna.key \
	-out /etc/ssl/certs/migferna.crt

EXPOSE 21 30020 30030

ENTRYPOINT ["vsftpd"] 
CMD ["/srcs/vsftpd.conf"]
