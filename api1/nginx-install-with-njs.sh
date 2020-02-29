#make sure to put the license files into the folder that this scipt is run from.
#scipt needs to be run with sudo sh plus-install.sh

#check for keys in local dir before proceeding:
[ ! -f nginx-repo.key ]  &&  echo "Check to see if nginx-repo.key and nginx-repo.crt exists in the current direcotry. Exiting." && exit 0 || echo "NGINX repo keys exist"

sudo mkdir -p /etc/ssl/nginx
sudo cp nginx-repo.key  /etc/ssl/nginx
sudo cp nginx-repo.crt  /etc/ssl/nginx

sudo [ -f nginx_signing.key ] && echo "nginx_signing.key exists" || sudo wget http://nginx.org/keys/nginx_signing.key

sudo apt-key add nginx_signing.key
sudo apt-get -y install apt-transport-https lsb-release ca-certificates

sudo printf "deb https://plus-pkgs.nginx.com/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list

[ -f 90nginx ] && echo "90nginx exists" || wget https://cs.nginx.com/static/files/90nginx
sudo mv 90nginx /etc/apt/apt.conf.d

sudo apt update
sudo apt -y install nginx-plus nginx-plus-module-njs

sudo sed -i '4 i\load_module modules/ngx_http_js_module.so;\nload_module modules/ngx_stream_js_module.so;' /etc/nginx/nginx.conf

[ -f nginx-plus-api.conf ] && echo "nginx-plus-api.conf exist" || wget https://gist.githubusercontent.com/nginx-gists/a51341a11ff1cf4e94ac359b67f1c4ae/raw/bf9b68cca20c87f303004913a6a9e9032f24d143/nginx-plus-api.conf
sudo mv nginx-plus-api.conf /etc/nginx/conf.d/

sudo systemctl enable nginx
sudo systemctl start nginx
sudo nginx -v 
