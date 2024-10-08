#!/bin/bash

echo "-----Initalizing setup process-----"

##### Install basic packages #####
sudo apt update -y
sudo apt install -y curl git net-tools lsb-release gnupg

echo "--------SET NETWORK CONFIGURATION------"
#Set network configuration netplan
#sudo mv 50-cloud-init.yaml 50-cloud-init_old.yaml
# copy netplan file from cloud
#sudo netplan apply
ifconfig


##### Install docker #####
echo "--------INSTALLING DOCKER------"

#Remove old docker versions if neccessary
sudo apt remove docker docker-engine docker.io containerd runc

#Add Docker official GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

#Install docker enine
sudo apt update -y
sudo apt install -y docker-ce
sudo usermod -aG docker ${USER}
sudo systemctl status docker

#Install docker compose
echo "------INSTALLING DOCKER COMPOSE-----"
sudo apt install -y docker-compose


echo "------GET EMQX BROKER-----"
#GET EMQX broker
#sudo curl -fsSL https://repos.emqx.io/gpg.pub | sudo apt-key add -
#sudo add-apt-repository "deb [arch=amd64] https://repos.emqx.io/emqx-ce/deb/ubuntu/ $(lsb_release -cs) stable"
#sudo apt update -y
#sudo apt install -y emqx

echo "------GET EMQX CONTAINER------"
sudo docker pull --platform linux/arm64 emqx/emqx:5.7.2

echo "------GET INFUX-DB CONTAINER-----"
sudo docker pull --platform linux/arm64 influxdb:2.7.10-alpine

echo "------GET TELEGRAF CONTAINER-----"
sudo docker pull --platform linux/arm64 telegraf:1.31.3

echo "------PULL API CONTAINER-----"
#sudo docker pull ghcr.io/matrueba/smart_control_api:master

#ONLY FOR RPI PLATFORM
echo "------CLONE AND BUILD API-----"
sudo git clone git@github.com:matrueba/smart_control_api.git
cd smart_control_api
sudo docker image build -t smart_control_api .

#echo "------RUN CONTAINERS-----"
#sudo docker network create --driver bridge influxdb-telegraf-net
#sudo docker run -d -p 8086:8086 --name=influxdb -v influx-data:/var/lib/influx --net=influxdb-telegraf-net influxdb
#sudo docker run -d -p 1883:1883 --name=emqx -v emqx-data:/var/lib/emqx emqx:4.3.8
#sudo docker run -d --name=telegraf -v ./telegraf/mytelegraf.conf:/etc/telegraf/telegraf.conf --net=influxdb-telegraf-net telegraf
