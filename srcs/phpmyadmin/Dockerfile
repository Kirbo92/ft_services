FROM alpine

RUN apk add phpmyadmin

COPY ./srcs/config.inc.php /etc/phpmyadmin/config.inc.php

EXPOSE 5000

ENTRYPOINT ["php"]
CMD ["-S", "0.0.0.0:5000", "-t",  "/usr/share/webapps/phpmyadmin"]
