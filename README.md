# NGINX Ansible Controller Workshop

This workshop is to show how to deploy NGINX using Ansible and then connect that NGINX Plus instance to NGINX Controller that is already running.

The AWS VM is already provisioned for you and has ansible installed and this github repository cloned to it.
The username / password are: nginx / Nginx1122!

------------

To save AWS costs, the workshop uses a single host that will use the locally installed ansible to run playbooks that will ssh to the localhost to install NGINX Plus and the Controller-Agent. It also uses docker to create a couple web services. 

Continue on to the workshpo:
<https://github.com/jessegoodier/NGINX-Ansible-Controller-Workshop/blob/master/1-Workshop_Prep_Guide.md>