#!/bin/bash
# This script start the docker container

echo -e "Starting container image ubuntu18.04:cartographer"
read -p "Container name: " CONTAINERNAME

docker run -d -ti \
    -v $(pwd)/../docker_mount:/home/developer/docker_mount \
    --net=host \
    --name $CONTAINERNAME \
    --cap-add=SYS_PTRACE \
    --restart unless-stopped \
    ubuntu18.04:cartographer