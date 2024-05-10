#!/bin/bash

sudo su
yum update -y
yum install -y docker
service docker start
usermod -a -G docker ec2-user

docker login --username DOCKER_USER --password DOCKER_PASSWORD
docker run --publish --detach --env BAR=FOO 3000:__PORT__ DOCKER_USER/FRONTEND:VERSION
docker run --publish --detach --env BAR=FOO 5000:__PORT__ DOCKER_USER/BACKEND:VERSION