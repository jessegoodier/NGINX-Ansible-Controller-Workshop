#!/bin/bash
echo "Removing old workshop-api1 and api2 containers"
sudo docker container rm -f workshop-api1 workshop-api2
echo "Starting API1 and API2"
sudo docker run --restart unless-stopped --name workshop-api1 -d -p 81:80 -v $PWD/api1/:/app webdevops/php-nginx
sudo docker run --restart unless-stopped --name workshop-api2 -d -p 82:80 -v $PWD/api2/:/app webdevops/php-nginx

echo " test out: curl localhost:81"
echo " and curl localhost:82"