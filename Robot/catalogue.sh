#!/bin/bash

set -e

COMPONENT=catalogue
source Robot/common.sh  # Source loads a file and this file all the common patterns

echo -e "\e[32m ________ $COMPONENT Configuration is Starting _______ \e[0m"

echo -n "Configuring NodeJS Repo : "
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> "$LOGFILE"
yum install nodejs -y  &>> "$LOGFILE"
stat $?

echo -e "Checking Application User $APPUSER existence ... "
id $APPUSER &>> "$LOGFILE"
echo -e "After ID cmd "
if [ $? -ne 0 ] ; then
    echo -e "Creating Application User $APPUSER : "
    useradd $APPUSER  &>> "$LOGFILE"
    stat $?
else
    echo -n "Application User $APPUSER already exists: " 
    stat $?   
fi 

echo -n "Downloading the $COMPONENT : "
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
stat $?

echo -n "Cleanup and Extraction of $COMPONENT : "
rm -rf /home/$APPUSER/$COMPONENT/
cd /home/roboshop
unzip -o /tmp/catalogue.zip &>> "$LOGFILE"
stat $?

echo -n "Changing the ownership to $APPUSER : "
mv /home/$APPUSER/$COMPONENT-main /home/$APPUSER/$COMPONENT
chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT
stat $?

echo -n "Installing $COMPONENT Dependencies : "
cd $COMPONENT
npm install &>> "$LOGFILE"
stat $?

echo -n "Configuring the $COMPONENT service : "
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service
mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
stat $?

echo -n "Starting $COMPONENT Service : "
systemctl daemon-reload        &>> "$LOGFILE"
systemctl enable catalogue     &>> "$LOGFILE"
systemctl restart catalogue    &>> "$LOGFILE"
stat $?

echo -e "\e[32m ________ $COMPONENT Configuration Completed _______ \e[0m"
