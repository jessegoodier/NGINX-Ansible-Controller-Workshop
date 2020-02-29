# Workshop Guide

We will use an AWS VM provisioned for you. 

---

## Installation Steps:

  1. ssh into your VM using the username nginx and password Nginx1122!
  2. optional: set your hostname with: 
     1. sudo hostnamectl set-hostname yourname 
  3. Install docker on this VM
     1. sudo apt install docker.io
  4. Install docker-compose: 
     1. sudo apt install docker-compose
     2. cd NGINX-Core-AWS-Workshop
  5. Run a script that will create the web services used in this workshop 
     1. >sh start_containers.sh
  6. Wait 30 seconds or so for the ergastdb to init. Run these tests:
     1. >curl localhost:81
     2. >curl localhost:8001/api/f1
  7. Verify that nginx is not running
     1. >curl localhost

---

Note that a shared controller instance is already running, but if you wanted to install it yourself, you would follow this guide. The binary has already been downloaded to your users home folder.

<https://docs.nginx.com/nginx-controller/admin-guide/installing-nginx-controller/>

## Next

Contnue on to install and configure NGINX Plus:
<https://github.com/jessegoodier/NGINX-Core-AWS-Workshop/blob/master/2-Workshop_Config_Guide.md>
