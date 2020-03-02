# Workshop Guide

We will use an AWS VM provisioned for you. 

---

## Installation Steps:

  1. ssh into your VM using the username nginx and password Nginx1122!
  2. optional: set your hostname with: 
     1. sudo hostnamectl set-hostname yourname 
  3. Run the script to install our required dependencies for the 
     1. cd NGINX-Core-AWS-Workshop
     2. sudo ./0-install-required-dependencies.sh\
  4. Run these tests to ensure the docker containers are up:
     1. >curl localhost:81
     2. >curl localhost:82
  5. Verify that nginx is not running
     1. >curl localhost

---

Note that a shared Controller instance is already running, but if you wanted to install it yourself, you would follow this guide. The binary has already been downloaded to your users home folder.

<https://docs.nginx.com/nginx-controller/admin-guide/installing-nginx-controller/>

## Next

Continue on to install and configure NGINX Plus:
<https://github.com/jessegoodier/NGINX-Ansible-Controller-Workshop/blob/master/2-Workshop_Config_Guide.md>
