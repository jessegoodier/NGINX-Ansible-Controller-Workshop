# Workshop Config Guide

## Install NGINX Plus using Ansible:

1. Change directory into the cloned github repo 
   1. >cd NGINX-Ansible-Controller-Workshop
2. Look at the playbook to make sure it isn't doing anything fishy, note the host groups that will be targeted (loadbalancers). Also view the hosts files to see which host(s) will be updated.
   1. >cat nginx_plus.yaml
   2. >cat hosts
3. Run the Ansible playbook to install NGINX Plus. (use option 1 or 2)
   1. >ansible-playbook nginx_plus.yaml -b -i hosts
   2. >./1-run-nginx_plus-playbook.sh


## Open the Controller GUI / Install agent on VM

4. <https://controller1.ddns.net> (User: nginx@nginx.com / Nginx1122!)
5. Click the upper left NGINX logo and Infrastructure section>graphs. Note that your instance isn't there. 
6. Go back to your ssh session and run the controller agent install playbook. (use option 1 or 2)
   1. >ansible-playbook nginx_controller_agent_3x.yaml -b -i hosts -e "user_email=nginx@nginx.com user_password=Nginx1122! controller_fqdn=controller1.ddns.net"
   2. >./2-run-nginx_controller_agent_3x-playbook.sh

## Configure Load Balancing Within Controller GUI

4. Wait for the new instance to appear and then feel free to change the alias by clicking the settings (gear icon) so it is easy for you to find.
5. Click on the NGINX logo and select Services. On the right navigation, select App>Create App.
6. Fill out the required fields with something you'll rememember (like yourname_app). 
7. Select the production environment and hit submit.
8. Select your app and create a component for it named time_component.
9. Click next and create a new gateway, call it yourname_gw, hit next.
10. Select your NGINX instance, hit next.
11. Under the hostnames, add http://localhost
12. Publish the gateway.
13. You will be back in your app and your gateway is selected, hit next.
14. In the URI section, add https://time_server and http://time_server and hit done. 
15. Select the nginx.ddns.net certificate and only allow TLSv1.2 and TLS1.3 
16. In your app, add a workload group. Name it time_server 
17. Add 2 backend workload URIs: http://localhost:81 and http://localhost:82 Be sure to hit done after adding each URI.
18. Hit publish
19. Open a web browser to https://your-aws-IP and refresh a few times to see the load balancing (or use curl on the ssh client)
20. View the changes made to /etc/nginx/nginx.conf on your host. 
    1.  >sudo nginx -T
21. Remove your app by removing the component first, then the app.

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
23. Review the JWT Identity Provider under the API Managment Section. A JWT has been configured. It is in this repo, named auth_jwt_key_file.jwk.
24. Go back to your API Definition and edit your published API to require an Authentication Policy using the JWT Provider. 
25. Publish and test a curl command using this token:
   ````
      curl -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6IjAwMDEifQ.eyJuYW1lIjoiUXVvdGF0aW9uIFN5c3RlbSIsInN1YiI6InF1b3RlcyIsImV4cCI6IjE2MDk0NTkxOTkiLCJpc3MiOiJNeSBBUEkgR2F0ZXdheSJ9.lJfCn7b_0mfKHKGk56Iu6CPGdJElG2UhFL64X47vu2M" localhost/api/f1/seasons
````

Optional, if you have time:

1.  Add an alert for too many 500 errors.
2.  Create a dashboard that you think might be useful in a NOC.
3.  access the Developer API Management Portal: http://3.19.238.184:8090
Feel free to browse around the GUI to see other functionality. 
