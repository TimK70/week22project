#!/bin/bash
sudo yum -y update
sudo yum -y install nginx
systemctl start nginx
systemctl enable nginx
echo "<h2>My NGINX Webserver</h2><br>Built by Terraform" > /var/www/html/index.html"