# Workshop Config Guide


## Install NGINX Plus using Ansible:

1. Change directory into the cloned github repo 
   1. >cd NGINX-Ansible-Controller-Workshop
2. Look at the playbook to make sure it isn't doing anything fishy, note the host groups that will be targeted (loadbalancers). Also view the hosts files to see which host(s) will be updated.
   1. >cat nginx_plus.yaml
   2. >cat hosts
3. Run the Ansible playbook to install NGINX Plus.
   1. >ansible-playbook nginx_plus.yaml -b -i hosts


## Open the Controller GUI / Install agent on VM

4. <https://controller1.ddns.net> (User: nginx@nginx.com / Nginx1122!)
5. Click the upper left NGINX logo and Infrastructure section. Note that your instance isn't there. 
6. Go back to your ssh session and run the controller agent install playbook.
   1. nginx_controller_agent_3x.yaml -b -i hosts -e "user_email=nginx@nginx.com user_password=Nginx1122! controller_fqdn=controller1.ddns.net"

## Configure Load Balancing Within Controller gui

4. Wait for the new instance to appear, change the alias by clicking the settings (gear icon) so it is easy for you to find. 

5a. Click on the NGINX logo and select Services. On the right navigation, select App>Create. 

5b. Fill out the required fields with something you'll rememember (like yourname_app). Select the prod environment and hit submit.

6. Select your app and create a component for it named time_component.

7a. Click next and create a new gateway, call it yourname_gw, hit next

7b. Select your NGINX instance, hit next and publish

8a. In the URI section, add https://time_server and http://time_server and hit done. 

8b. Select the aws-nlb certificate and only allow TLSv1.2 and TLS1.3 > next.

9a. Hit next down to Add a workload group. Name it yourname_workload_group 

9b. Add 2 backend workload URIs: http://localhost:81 and http://localhost:82 Be sure to hit done after adding each URI.

9c. Hit publish

10. Run a curl (or web browser) to https://IP of your plus instance and refresh a few times to see the load balancing.

11.  View the changes made to /etc/nginx/nginx.conf on your host. Try running "nginx -T"

## Configure API Management

12. Navigate to Services>APIs and Create a workload group Your name Workload group. Add localhost on ports 8001 and 8002. Normally these would be different hosts (pool members)

13. On API Definitions create your "F1 Yourname" API with base path /api/f1

14. Hit save and add URI /seasons and /drivers. Enable documentation with response 200 and {"response":"2009"} as an example (you can make this up, it is just for future developers who might consume this API resource)

15. Click Add A Published API f1_api in prod and create a new application "yourname_f1_app"

17. Select the entry point, click save. 

18. Scroll to the bottom and add the routes to the resources we created.

19. Publish and wait for the success message.

20. curl a few of these examples:

```
curl -k http://localhost/api/f1/seasons
curl -k http://localhost/api/f1/drivers
curl -k http://localhost/api/f1/drivers.json
curl -k http://localhost/api/f1/drivers/arnold.json
```

21. Because json is better, let's force all responses to be json. Edit the config and add a rule>rewrite rule matching ^(.*)$ to $1.json

22. Publish and test a couple more requests.

Optional, if you have time:

23. Add an alert for too many 500 errors.

24. Create a dashboard that you think might be useful in a NOC.

25. access the Developer API Management Portal: http://3.17.61.103:8090
Feel free to browse around the GUI to see other functionality. 
