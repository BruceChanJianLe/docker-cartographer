#!/bin/bash
# This script connect this terminal to specific docker container

# Display all container's name
echo "List of containers:"
declare -a arr
i=0

# Make container name into an array
containers=$(docker ps -a | awk '{if(NR>1) print$NF}')
for container in $containers
do
    arr[$i]=$container
    let "i+=1"
done

# Loop through name array
let "i-=1"
for j in $(seq 0 $i)
do
    echo $j")" ${arr[$j]}
done

# Obtain container name
read -p "Container name to be connected: " CONTAINERNAME

if [[ -z ${arr[$CONTAINERNAME]} ]]
then
    docker exec -ti $CONTAINERNAME env TERM=xterm-256color bash -l
else
    docker exec -ti ${arr[$CONTAINERNAME]} env TERM=xterm-256color bash -l
fi