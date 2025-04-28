#!/bin/bash

cd nginx

docker build -t my-nginx .

docker run -d -p 54321:80 --name my-nginx-container my-nginx

docker ps -a
sleep 5
curl 127.0.0.1:54321

echo "Nginx container is running and accessible on port 54321"