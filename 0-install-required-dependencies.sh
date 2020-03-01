sudo apt -y install docker.io docker-compose python2.7 jq
sudo systemctl enable docker
sudo sh start_containers.sh
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
ansible-galaxy install nginxinc.nginx 
ansible-galaxy install git+https://github.com/brianehlert/ansible-role-nginx-controller-generate-token.git
ansible-galaxy install git+https://github.com/brianehlert/ansible-role-nginx-controller-agent.git
