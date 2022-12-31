#!/bin/bash

ID=$(id -u)

if [ $ID -ne 0 ] ; then
   echo -e "\e[31m You need to run the script as a root user or with a sudo privilege\e[0m"
   exit 1
fi 

echo -n "Installing Nginx :"
yum install nginx -y     &>> /tmp/frontend.log
if [ $? -eq 0 ] ; then
    echo -e "\e[32mSuccess\e[0m"
else
    echo -e "\e[31mFailure\e[0m"
fi

echo -n "Starting Nginx :"
systemctl enable nginx   &>> /tmp/frontend.log
systemctl start nginx    &>> /tmp/frontend.log
if [ $? -eq 0 ] ; then
    echo -e "\e[32mSuccess\e[0m"
else
    echo -e "\e[31mFailure\e[0m"
fi

curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
