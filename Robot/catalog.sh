#!/bin/bash

set -e

COMPONENT=catalog
source Robot/common.sh  # Source loads a file and this file all the common patterns

echo -e "\e[32m ________ $COMPONENT Configuration is Starting _______ \e[0m"

echo -n "Configuring NodeJS Repo : "
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> "$LOGFILE"
yum install nodejs -y  &>> "$LOGFILE"
stat $?

echo -e "Checking Application User $APPUSER existence: "
id $APPUSER &>> "$LOGFILE"
if [ $? -ne 0 ] ; then
    echo -e "Creating Application User $APPUSER : "
    useradd $APPUSER  &>> "$LOGFILE"
    stat $?
else
    echo -e "Application User $APPUSER already exists: "    
fi 

echo -e "\e[32m ________ $COMPONENT Configuration Completed _______ \e[0m"
