# Workshop Config Guide

## Install NGINX Plus using Ansible:

1. Change directory into the cloned github repo 
   1. >cd NGINX-Ansible-Controller-Workshop
2. Look at the playbook to make sure it isn't doing anything fishy, note the host groups that will be targeted (loadbalancers). Also view the hosts files to see which host(s) will be updated.
   1. >cat nginx_plus.yaml
   2. >cat hosts
3. Run the Ansible playbook to install NGINX Plus.
   1. >ansible-playbook nginx_plus.yaml -b -i hosts
   2. >./1-run-nginx_plus-playbook.sh


## Open the Controller GUI / Install agent on VM

4. <https://controller1.ddns.net> (User: nginx@nginx.com / Nginx1122!)
5. Click the upper left NGINX logo and Infrastructure section>graphs. Note that your instance isn't there. 
6. Go back to your ssh session and run the controller agent install playbook.
   1. >ansible-playbook nginx_controller_agent_3x.yaml -b -i hosts -e "user_email=nginx@nginx.com user_password=Nginx1122! controller_fqdn=controller1.ddns.net"
   2. >./2-run-nginx_controller_agent_3x-playbook.sh

## Configure Load Balancing Within Controller GUI

4. Wait for the new instance to appear and then feel free to change the alias by clicking the settings (gear icon) so it is easy for you to find.
5. Click on the NGINX logo and select Services. On the right navigation, select App>Create App.
6. Fill out the required fields with something you'll rememember (like yourname_app). Select the prod environment and hit submit.
7. Select your app and create a component for it named time_component.
8. Click next and create a new gateway, call it yourname_gw, hit next
9. Select your NGINX instance, hit next and publish
10. In the URI section, add https://time_server and http://time_server and hit done. 
11. Select the aws-nlb certificate and only allow TLSv1.2 and TLS1.3 > next.
12. Hit next down to Add a workload group. Name it yourname_workload_group 
13. Add 2 backend workload URIs: http://localhost:81 and http://localhost:82 Be sure to hit done after adding each URI.
14. Hit publish
15. Open a web browser to https://<your-aws-IP> and refresh a few times to see the load balancing (or use curl on the ssh client)
16. View the changes made to /etc/nginx/nginx.conf on your host. 
    1.  >sudo nginx -T

## Configure API Management

1.  Navigate to Services>APIs and Create a workload group Your name Workload group. Add ergast.com on port 80. 
2.  On API Definitions create your "F1 Yourname" API with base path /api/f1
3.  Hit save and add URI /seasons and /drivers. Enable documentation with response 200 and {"response":"2009"} as an example (you can make this up, it is just for future developers who might consume this API resource)
4.  Click Add A Published API f1_api in prod and create a new application "yourname_f1_app"
5.  Select the entry point, click save. 
6.  Scroll to the bottom and add the routes to the resources we created.
7.  Publish and wait for the success message.
8.  curl a few of these examples:
```
   curl -k http://localhost/api/f1/seasons
   curl -k http://localhost/api/f1/drivers
   curl -k http://localhost/api/f1/drivers.json
   curl -k http://localhost/api/f1/drivers/arnold.json
```

21. Edit your published API and add a rate limit policy.
22. Publish and test a couple more requests.

Optional, if you have time:

23. Add an alert for too many 500 errors.
24. Create a dashboard that you think might be useful in a NOC.
25. access the Developer API Management Portal: http://3.17.61.103:8090
Feel free to browse around the GUI to see other functionality. 
