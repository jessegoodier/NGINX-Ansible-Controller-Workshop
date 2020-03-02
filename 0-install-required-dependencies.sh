sudo apt -y install docker.io docker-compose python2.7 jq
sudo systemctl enable docker
sudo sh start_containers.sh
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt - y install ansible
ansible-galaxy install nginxinc.nginx 
#ansible-galaxy collection install nginxinc.nginx_controller
ansible-galaxy install nginxinc.nginx_controller_generate_token
ansible-galaxy install nginxinc.nginx_controller_agent
