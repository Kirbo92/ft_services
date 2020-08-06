FROM alpine

COPY ./srcs /srcs

RUN apk add influxdb

CMD influxd run -config /etc/influxdb.conf

