FROM alpine

COPY ./srcs /srcs

RUN apk update && apk add --no-cache --upgrade bash && \
	apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main libc6-compat && \
	chmod +x /srcs/telegraf-1.15.2/usr/bin

WORKDIR /srcs/telegraf-1.15.2/usr/bin

CMD ping google.es
#CMD ./telegraf -sample-config -input-filter docker -output-filter influxdb > telegraf.conf && \
#	./telegraf --config telegraf.conf
