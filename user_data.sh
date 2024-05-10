#!/bin/bash

sudo su
yum update -y
yum install -y docker
service docker start
usermod -a -G docker ec2-user

docker run --publish --detach 3000:3000 zanadreis/portifolio-frontend
docker run --publish --detach 5000:5000 zanadreis/portifolio-backend