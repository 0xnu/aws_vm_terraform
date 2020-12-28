#!/bin/sh
# install nginx
echo "Running bootstrap script...";
echo "Installing nginx...";
sudo apk update
sudo apk add nginx
# copying configuration and content.
echo "Copying nginx configuration...";
sudo cp /tmp/bootstrap/default.conf /etc/nginx/conf.d/
sudo dos2unix /etc/nginx/conf.d/default.conf
echo "Copying web content...";
sudo cp /tmp/bootstrap/content/* /var/www/localhost/htdocs/
# start nginx
sudo service nginx start;
echo "...Bootstrap script completed.";
