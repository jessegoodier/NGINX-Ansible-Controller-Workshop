# Workshop Config Guide

## Install NGINX Plus using Ansible:

1. ssh into your VM using the username nginx and password Nginx1122!
2. Set your hostname with: 
  1. >sudo hostnamectl set-hostname yourname 
3. Install our required dependencies for the workshop.
   1. >cd NGINX-Ansible-Controller-Workshop 
   2. >sh 0-install-required-dependencies.sh
4. Verify that nginx is not running
  2. >curl localhost
5. Change directory into the cloned github repo 
   1. >cd NGINX-Ansible-Controller-Workshop 
6. Look at the playbook to make sure it isn't doing anything fishy, note the host groups that will be targeted (loadbalancers). Also view the hosts files to see which host(s) will be updated.
   1. >cat nginx_plus.yaml
   2. >cat hosts
7. Run the Ansible playbook to install NGINX Plus. (use option 1 or 2)
   1. >ansible-playbook nginx_plus.yaml -b -i hosts
   2. >sh 1-run-nginx_plus-playbook.sh

## Open the Controller GUI / Install agent on VM

8. <https://controller1.ddns.net> (User: admin@nginx.com / Nginx1122!)
9. Click the upper left NGINX logo and Infrastructure section>graphs. Note that your instance isn't there. 
10. Go back to your ssh session and run the controller agent install playbook. (use option 1 or 2)
   1. >ansible-playbook nginx_controller_agent_3x.yaml -b -i hosts -e "user_email=admin@nginx.com user_password=Nginx1122! controller_fqdn=controller1.ddns.net"
   2. >sh 2-run-nginx_controller_agent_3x-playbook.sh

## Configure Load Balancing Within Controller GUI

11. Wait for the new instance to appear and then feel free to change the alias by clicking the settings (gear icon) so it is easy for you to find.
12. Click on the NGINX logo and select Services. On the right navigation, select App>Create App.
13. Fill out the required fields with something you'll rememember (like yourname_app). 
14. Select the production environment and hit submit.
15. Select your app and create a component for it named time_component.
16. Click next and create a new gateway, call it yourname-gw, hit next.
17. Select your NGINX instance, hit next.
18. Under the hostnames, add http://localhost
19. Publish the gateway.
20. You will be back in your app and your gateway is selected, hit next.
21. In the URI section, add (link is on top right of screen) 
    1.  >https://time_server 
    2.  >http://time_server 
22. Hit done. 
23. Select the nginx.ddns.net certificate and only allow TLSv1.2 and TLS1.3 
24. In your app, add a workload group. Name it time_server 
25. Add 2 backend workload URIs: 
    1.  >http://18.223.169.105
    2.  >http://3.16.214.214
    3.  Be sure to hit done after adding each URI.
26. Hit publish
27. Open a web browser to https://your-aws-IP and refresh a few times to see the load balancing (or use curl on the ssh client)
28. View the changes made to /etc/nginx/nginx.conf on your host. 
    1.  >sudo nginx -T
29. Remove your app by removing the component first, then the app.

## Configure API Management

30. Navigate to Services>APIs and view the workload group. (ergast.com:80) 
31. On API Definitions create your "F1 Yourname" API with base path /api/f1
32. Hit save and add URI /seasons and /drivers. Enable documentation with response 200 and {"response":"2009"} as an example (you can make this up, it is just for future developers who might consume this API resource)
33. Click Add A Published API f1_api in prod and create a new application "yourname_f1_app"
34. Select the entry point, click save.
35. Scroll to the bottom and add the routes to the resources we created.
36. Publish and wait for the success message.
37. curl a few of these examples:
```
   curl -k http://localhost/api/f1/seasons
   curl -k http://localhost/api/f1/drivers
   curl -k http://localhost/api/f1/drivers.json
   curl -k http://localhost/api/f1/drivers/arnold.json
```

38. Edit your published API and add a rate limit policy.
39. Publish and test a couple more requests.
40. Review the JWT Identity Provider under the API Managment Section. A JWT has been configured. It is in this repo, named auth_jwt_key_file.jwk.
41. Go back to your API Definition and edit your published API to require an Authentication Policy using the JWT Provider. 
42. Publish and test a curl command using this token (which is in the script in option 2). Alternatively, use postman.
    1.  >curl -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6IjAwMDEifQ.eyJuYW1lIjoiUXVvdGF0aW9uIFN5c3RlbSIsInN1YiI6InF1b3RlcyIsImV4cCI6IjE2MDk0NTkxOTkiLCJpc3MiOiJNeSBBUEkgR2F0ZXdheSJ9.lJfCn7b_0mfKHKGk56Iu6CPGdJElG2UhFL64X47vu2M" localhost/api/f1/seasons
    2.  >sh 3-run-jwt-curl.sh


Optional, if you have time:

43. Add an alert for too many 500 errors.
44. Create a dashboard that you think might be useful in a NOC.
45. Access the Developer API Management Portal: http://3.19.238.184:8090
Feel free to browse around the GUI to see other functionality. 
