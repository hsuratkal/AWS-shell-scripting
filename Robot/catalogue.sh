#!/bin/bash

set -e

COMPONENT=frontend

source Robot/common.sh  # Source loads a file and this file all the common patterns

echo -e "\e[32m ________ $COMPONENT Configuration is Starting _______ \e[0m"


# curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
# yum install nodejs -y

# useradd roboshop

$ curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
$ cd /home/roboshop
$ unzip /tmp/catalogue.zip
$ mv catalogue-main catalogue
$ cd /home/roboshop/catalogue
$ npm install

$ vim systemd.servce

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue
# systemctl status catalogue -l
