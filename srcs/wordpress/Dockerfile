FROM alpine

RUN apk update && \
	apk add php7 php7-fpm php7-mbstring php7-mysqli php7-json && \
	mkdir -p /www/wordpress/ && \
	wget https://es.wordpress.org/latest-es_ES.tar.gz -P /www/wordpress/ && \
	tar xzvf /www/wordpress/latest-es_ES.tar.gz -C /www/ && \
	rm -rf /www/wordpress/latest-es_ES.tar.gz

COPY /srcs/wp-config.php /www/wordpress/wp-config.php

CMD php -S 0.0.0.0:5050 -t /www/wordpress
