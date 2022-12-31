#!/bin/bash

set -e

COMPONENT=catalogue

source Robot/common.sh  # Source loads a file and this file all the common patterns

echo -e "\e[32m ________ $COMPONENT Configuration is Starting _______ \e[0m"

echo -n "Configuring NodeJS Repo : "
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
yum install nodejs -y  &>> $LOGFILE
stat $?

echo -n "Creating Application User $APPUSER : "
useradd $APPUSER  &>> $LOGFILE
stat $?



echo -e "\e[32m ________ $COMPONENT Configuration Completed _______ \e[0m"
