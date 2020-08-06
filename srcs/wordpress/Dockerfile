FROM alpine

COPY ./srcs/wordpress /www/wordpress

RUN apk update && \
	apk add php7 php7-fpm php7-mysqli php7-json
CMD php -S 0.0.0.0:5050 -t /www/wordpress
