#!/bin/bash

# COLORS #
GREEN='\x1b[32m'
END='\x1b[0m'
BLINK='\x1b[5m'

if ! minikube status >> /dev/null 2>&1; then
	minikube start --driver=virtualbox
fi

## METAL LB ##
echo -e "${GREEN}MetalLB${END}"
# see what changes would be made, returns nonzero returncode if different
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system

# actually apply the changes, returns nonzero returncode on errors only
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

kubectl apply -f srcs/metalLB.yaml


kubectl delete deployments --all
kubectl delete svc --all
#kubectl delete pv --all
#kubectl delete pvc --all

eval $(minikube docker-env)

IP=$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)
printf "Minikube IP: ${IP}"

echo -e "${GREEN}Docker Build${END}"
docker build -t my-nginx srcs/nginx > /dev/null 2>&1
docker build -t my-mysql srcs/mysql > /dev/null 2>&1
docker build -t my-wordpress srcs/wordpress > /dev/null 2>&1
docker build -t my-ftps srcs/ftps > /dev/null 2>&1
docker build -t my-phpmyadmin srcs/phpmyadmin > /dev/null 2>&1
docker build -t my-grafana srcs/grafana > /dev/null 2>&1
docker build -t my-influxdb srcs/influxdb > /dev/null 2>&1
docker build -t my-telegraf srcs/telegraf > /dev/null 2>&1
echo -e "${GREEN}Docker build completed${END}"

echo -e "${GREEN}Deploy Init${END}"
kubectl apply -f srcs/nginx.yaml
kubectl apply -f srcs/mysql.yaml
kubectl apply -f srcs/wordpress.yaml
kubectl apply -f srcs/ftps.yaml
kubectl apply -f srcs/phpmyadmin.yaml
kubectl apply -f srcs/grafana.yaml
kubectl apply -f srcs/influxdb.yaml
kubectl apply -f srcs/telegraf.yaml
echo -e "${GREEN}Deploy Finish${END}"

NGINX_IP=`kubectl get services | awk '/nginx/ {print $4}'`
WORDPRESS_IP=`kubectl get services | awk '/wordpress/ {print $4}'`
PHPMYADMIN_IP=`kubectl get services | awk '/php/ {print $4}'`
GRAFANA_IP=`kubectl get services | awk '/grafana/ {print $4}'`

echo "NGINX: http://$NGINX_IP/"
echo "Wordpress: http://$WORDPRESS_IP:5050/"
echo "PhpMyAdmin: http://$PHPMYADMIN_IP:5000/"
echo "Grafana: http://$GRAFANA_IP:3000/"
