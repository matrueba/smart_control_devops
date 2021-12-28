#!/bin/bash

echo "-----Initalizing setup process-----"

##### Install basic packages #####
sudo apt update -y
sudo apt install -y curl git net-tools lsb-release gnupg

echo "--------SET NETWORK CONFIGURATION------"
#Set network configuration netplan
sudo mv 50-cloud-init.yaml 50-cloud-init_old.yaml
# copy netplan file from cloud
sudo netplan apply
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
suo apt install -y docker-compose


echo "------GET EMQX BROKER-----"
#GET EMQX broker
sudo curl -fsSL https://repos.emqx.io/gpg.pub | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://repos.emqx.io/emqx-ce/deb/ubuntu/ $(lsb_release -cs) stable"
sudo apt update -y
sudo apt install -y emqx

echo "------GET EMQX CONTAINER------"
sudo docker pull emqx/emqx:4.3.8

echo "------GET NODE-RED CONTAINER-----"
sudo docker pull nodered/node-red

echo "------GET INFUX-DB CONTAINER-----"
#sudo docker pull --platform linux/arm64/v8 influxdb
sudo docker pull influxdb

echo "------GET TELEGRAF CONTAINER-----"
sudo docker pull telegraf

echo "------GET GRAFANA CONTAINER------"
sudo docker pull grafana/grafana

#echo "------RUN CONTAINERS-----"
#sudo docker run -d -p 1880:1880 --name nodered -v NodeREDdata:/var/lib/nodered
#sudo docker run -d -p 3000:3000 --name=grafana -v grafana-data:/var/lib/grafana
#sudo docker network create --driver bridge influxdb-telegraf-net
#sudo docker run -d -p 8086:8086 --name=influxdb -v influx-data:/var/lib/influx --net=influxdb-telegraf-net influxdb
#sudo docker run -d -p 1883:1883 --name=emqx -v emqx-data:/var/lib/emqx emqx:4.3.8
#sudo docker run -d --name=telegraf -v ./telegraf/mytelegraf.conf:/etc/telegraf/telegraf.conf --net=influxdb-telegraf-net telegraf
