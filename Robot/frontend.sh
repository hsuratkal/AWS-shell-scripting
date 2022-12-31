#!/bin/bash

set -e

COMPONENT=frontend

ID=$(id -u)

if [ $ID -ne 0 ] ; then
   echo -e "\e[31m You need to run the script as a root user or with a sudo privilege\e[0m"
   exit 1
fi 

stat() {
    if [ $1 -eq 0 ] ; then
        echo -e "\e[32mSuccess\e[0m"
    else
        echo -e "\e[31mFailure\e[0m"
    fi    
}
echo -n "Installing Nginx : "
yum install nginx -y     &>> /tmp/frontend.log
stat $?

echo -n "Starting Nginx : "
systemctl enable nginx   &>> /tmp/frontend.log
systemctl start nginx    &>> /tmp/frontend.log
stat $?

echo -n "Downloading the $COMPONENT : "
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?

echo -n "Clearing the default content : "
cd /usr/share/nginx/html
rm -rf *
stat $?

echo -n "Extracting $COMPONENT : "
unzip /tmp/frontend.zip &>> /tmp/$COMPONENT.log
stat $?

echo -n "Copying $COMPONENT : "
mv frontend-main/* .  &>> /tmp/$COMPONENT.log
mv static/* .         &>> /tmp/$COMPONENT.log
rm -rf frontend-main README.md   &>> /tmp/$COMPONENT.log
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>> /tmp/$COMPONENT.log 
stat $?

echo -n "Restarting Nginx : "
systemctl enable nginx   &>> /tmp/frontend.log
systemctl restart nginx    &>> /tmp/frontend.log
stat $?
