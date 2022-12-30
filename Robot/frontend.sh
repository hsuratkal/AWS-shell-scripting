#!/bin/bash

ID=$(id -u)

if [ $ID -ne 0 ] ; then
   echo -e "\e[31m You need to run the script as a root user or with a sudo privilege\e[0m"
   exit 1
fi 

echo "Installing Nginx :"
yum install nginx -y     &>> /tmp/frontend.log
if [ $? -eq 0] ; then
    echo -e "\e[32mSuccess\e[0m"
else
    echo -e "\e[31mFailure\e[0m"
fi

echo "Starting Nginx :"
systemctl enable nginx   &>> /tmp/frontend.log
systemctl start nginx    &>> /tmp/frontend.log