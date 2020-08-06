FROM alpine


COPY ./srcs /srcs/

RUN apk add vsftpd && \
	cp /srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf

EXPOSE 21 10090-10100
VOLUME /ftp

ENTRYPOINT vsftpd /etc/vsftpd/vsftpd.conf
