FROM alpine

COPY ./srcs/* /srcs/

RUN apk add phpmyadmin && \
	chmod +x /srcs/run.sh

COPY ./srcs/config.inc.php /etc/phpmyadmin/config.inc.php

EXPOSE 5000

ENTRYPOINT ["/srcs/run.sh"]
