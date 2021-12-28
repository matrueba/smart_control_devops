#!/bin/bash
sudo docker swarm init
sudo docker stack deploy -c docker_compose/docker-compose.yml smartbox --prune
