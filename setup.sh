#!/bin/bash

kubectl delete deployments --all
kubectl delete svc --all
#kubectl delete pv --all
#kubectl delete pvc --all

eval $(minikube docker-env)

docker build -t my-nginx srcs/nginx
docker build -t my-mysql srcs/mysql
docker build -t my-wordpress srcs/wordpress
docker build -t my-ftps srcs/ftps
docker build -t my-phpmyadmin srcs/phpmyadmin
docker build -t my-grafana srcs/grafana
docker build -t my-influxdb srcs/influxdb

kubectl apply -f srcs/nginx.yaml
kubectl apply -f srcs/ftps.yaml
kubectl apply -f srcs/wordpress.yaml
kubectl apply -f srcs/mysql.yaml
kubectl apply -f srcs/phpmyadmin.yaml
kubectl apply -f srcs/grafana.yaml
