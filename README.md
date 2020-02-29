# NGINX Ansible Controller Workshop

This workshop will deploy an NGINX Plus instance using Ansible and connect that instance to NGINX Controller that is already running.

The AWS instance provisioned for you already has ansible installed and this github repository cloned to it.
The username / password are: nginx / Nginx1122!


------------

Note: this workshop uses ansible roles that are currently not in ansible galaxy (as of 2/29/2020). If you want to duplicate this workshop in your own environment, add these roles: 

ansible-galaxy install nginxinc.nginx 
ansible-galaxy install git+https://github.com/brianehlert/ansible-role-nginx-controller-generate-token.git
ansible-galaxy install git+https://github.com/brianehlert/ansible-role-nginx-controller-agent.git


------------

To save AWS costs, the workshop uses a single host that will use the locally installed ansible to run playbooks that will ssh to the localhost to install NGINX Plus and the Controller-Agent. It also uses docker to create a couple web services. 

