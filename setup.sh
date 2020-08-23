#!/bin/bash

# COLORS #
GREEN='\x1b[32m'
END='\x1b[0m'
BLINK='\x1b[5m'

NGINX_IP=192.168.99.101
PHPMYADMIN_IP=192.168.99.102
WORDPRESS_IP=192.168.99.103
FTPS_IP=192.168.99.104
GRAFANA_IP=192.168.99.105

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
kubectl delete pvc --all
kubectl delete pv --all

eval $(minikube docker-env)

cp srcs/mysql/srcs/wordpress.sql.old srcs/mysql/srcs/wordpress.sql
cp srcs/ftps/srcs/vsftpd.conf.old srcs/ftps/srcs/vsftpd.conf
cp srcs/wordpress.yaml.old srcs/wordpress.yaml
cp srcs/nginx.yaml.old srcs/nginx.yaml
cp srcs/ftps.yaml.old srcs/ftps.yaml
cp srcs/phpmyadmin.yaml.old srcs/phpmyadmin.yaml
cp srcs/grafana.yaml.old srcs/grafana.yaml
sed -i '' "s/0.0.0.0/$WORDPRESS_IP/g" srcs/mysql/srcs/wordpress.sql
sed -i '' "s/0.0.0.0/$FTPS_IP/g" srcs/ftps/srcs/vsftpd.conf
sed -i '' "s/<WORDPRESS_IP>/$WORDPRESS_IP/g" srcs/wordpress.yaml
sed -i '' "s/<NGINX_IP>/$NGINX_IP/g" srcs/nginx.yaml
sed -i '' "s/<FTPS_IP>/$FTPS_IP/g" srcs/ftps.yaml
sed -i '' "s/<PHPMYADMIN_IP>/$PHPMYADMIN_IP/g" srcs/phpmyadmin.yaml
sed -i '' "s/<GRAFANA_IP>/$GRAFANA_IP/g" srcs/grafana.yaml

echo -e "${GREEN}Docker Build${END}"
docker build -t my-nginx srcs/nginx > /dev/null 2>&1
docker build -t my-mysql srcs/mysql > /dev/null 2>&1
docker build -t my-ftps srcs/ftps > /dev/null 2>&1
docker build -t my-phpmyadmin srcs/phpmyadmin > /dev/null 2>&1
docker build -t my-wordpress srcs/wordpress > /dev/null 2>&1
docker build -t my-grafana srcs/grafana > /dev/null 2>&1
docker build -t my-influxdb srcs/influxdb > /dev/null 2>&1
docker build -t my-telegraf srcs/telegraf > /dev/null 2>&1
echo -e "${GREEN}Docker build completed${END}"

echo -e "${GREEN}Deploy Init${END}"
kubectl apply -f srcs/nginx.yaml
kubectl apply -f srcs/mysql.yaml
kubectl apply -f srcs/ftps.yaml
kubectl apply -f srcs/phpmyadmin.yaml
kubectl apply -f srcs/wordpress.yaml
kubectl apply -f srcs/grafana.yaml
kubectl apply -f srcs/influxdb.yaml
kubectl apply -f srcs/telegraf.yaml
echo -e "${GREEN}Deploy Finish${END}"

echo "NGINX: http://$NGINX_IP/"
echo "PhpMyAdmin: http://$PHPMYADMIN_IP:5000/"
echo "Wordpress: http://$WORDPRESS_IP:5050/"
echo "FTPS: https://$FTPS_IP:21/"
echo "Grafana: http://$GRAFANA_IP:3000/"
