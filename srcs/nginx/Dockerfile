FROM alpine

COPY ./srcs/ /srcs

RUN apk update && \
    apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main libc6-compat nginx openssl openssh && \
	cp /srcs/default.conf /etc/nginx/conf.d/ && \
	mkdir -p /run/nginx

#RUN apk update && \
#	apk add openrc nginx && \
#	cp ./default.conf /etc/nginx/conf.d/ && \
#	openrc && \
#	touch /run/openrc/softlevel && \
#	mkdir -p /run/nginx

EXPOSE 80

#ENTRYPOINT nginx -g 'daemon off;'
ENTRYPOINT nginx -g 'daemon off;'

