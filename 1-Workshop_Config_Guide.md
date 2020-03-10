# Workshop Config Guide

## Install NGINX Plus using Ansible:

1. ssh into your VM using the username nginx and password Nginx1122!
2. Set your hostname with: 
   1. >sudo hostnamectl set-hostname yourname 
3. Install our required dependencies for the workshop.
   1. >cd NGINX-Ansible-Controller-Workshop 
   2. >sh 0-install-required-dependencies.sh
4. Verify that nginx is not running
   1. >curl localhost
5. Take a look at the playbook and note the host groups that will be targeted (loadbalancers). Also view the hosts files to see which host(s) will be updated. 
   1. >cat nginx_plus.yaml
   2. >cat hosts
   3. >cat nginx_plus_vars.yaml
6. Run the Ansible playbook to install NGINX Plus. (use option 1 or 2)
   1. Full command: 
         >ansible-playbook nginx_plus.yaml -b -i hosts
   2. Scripted equivalent
         >sh 1-run-nginx_plus-playbook.sh

## Open the Controller GUI / Install agent on VM

7. <https://controller1.ddns.net> (User: admin@nginx.com / Nginx1122!)
8. Click the upper left NGINX logo and Infrastructure section>graphs. Note that your instance isn't there. 
9.  Go back to your ssh session and run the controller agent install playbook. (use option 1 or 2)
    1. Full command: 
       >ansible-playbook nginx_controller_agent_3x.yaml -b -i hosts -e "user_email=admin@nginx.com user_password=Nginx1122! controller_fqdn=controller1.ddns.net"
    2. Scripted Equivalent: 
       >sh 2-run-nginx_controller_agent_3x-playbook.sh

## Configure Load Balancing Within Controller GUI

10. Go back to the Controller GUI and go to the Infrastructure>Graphs page
11. Wait for the new instance to appear and then feel free to change the alias by clicking the settings (gear icon) so it is easy for you to find.
12. Click on the NGINX logo and select Services. 
13. Go to the Gateways
14. Create a new gateway, call it yourname-gw
15. Put it in the production environment and hit next.
16. In the Placements, select your NGINX instance, hit next.
17. Under the hostnames, add 
    1.  http://nginx.ddns.net 
    2.  https://nginx.ddns.net 
    3.  Be sure to hit done after adding each URI.
18. Feel free to view the optional configuration options.
19. Publish the gateway and wait on the Gateways screen until your status is green.
20. On the leftmost column hit Apps to show the My Apps menu > select overview. Click one of the buttons that say Create App.
21. Name your app yourname-app and put it in the production environment. 
22. Hit submit.
23. You should be brought to the Apps list and you see your app listed. You now need to create a Component for your app. There are at least four ways to create this first component, but here is one way that is also available later to add more components: Hover over your app and hit the eye icon under the View column. This page provides an Overview for this entire app. Hit Create Component near the upper-right corner of the page.
24. Name the first component time1
25. In the Gateways section, select your gateway.
26. In the URI section, add (link is on top right of screen) uri: /time1
27. Hit done. 
28. Click next through the optional configuration items until you get to workload groups.
29. Add a workload group. Name it time1
30. Add the backend workload URI: http://18.223.169.105
31. Be sure to hit done after adding the URI.
32. Hit publish.
33. Wait for the green Configured status. 
34. Open a web browser to https://your-aws-IP/time1 and refresh a few times 
35. View the changes made to /etc/nginx/nginx.conf on your host. 
    1.  >sudo nginx -T
36. Repeat steps 24-35 adding a component for time2 and point it to http://3.16.214.214
37. Add another component and name it both.
38. Select your gateway. 
39. In the URI section add: / 
40. Click done.
41. Click on Workload groups and add a workload group called both
42. Add both of our backend workoad URIs:
    1.  http://18.223.169.105
    2.  http://3.16.214.214
43. Test the new configuration with a few curl commands on your SSH session:
    1.  curl localhost/time1
    2.  curl localhost/time2
    3.  curl localhost (run it several times to see the round robin)
    4.  curl -k https://localhost/ (to test https is working)
    5.  you can also test using the public IP of your VM in a browser

## Configure API Management

31. Navigate to Services>APIs and view the workload group. (ergast.com:80)
32. On API Definitions create your "F1 Yourname" API with base path /api/f1
33. Hit save and add URI /seasons and /drivers. Enable documentation with response 200 and {"response":"2009"} as an example (you can make this up, it is just for future developers who might consume this API resource)
34. Click Add A Published API f1_api in prod and create a new application "yourname_f1_app"
35. Select the entry point, click save.
36. Scroll to the bottom and add the routes to the resources we created.
37. Publish and wait for the success message.
38. curl a few of these examples:
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
45. Access the Developer API Management Portal: <http://[3.19.238.184:8090>
Feel free to browse around the GUI to see other functionality. 
