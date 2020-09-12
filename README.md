# Docker Cartographer

This repository demonstrates the steps to setting up cartographer inside a Ubuntu ROS container and using it.  

## Using the Dockerfile

Please refer to the building, starting and connecting steps below.  
Due to the nature of docker container and how google's cartographer is written. The configuration files and launch files needed to be compiled before the configurations can apply. Since the cartographer code is inside of the root directory under `catkin_ws`, I would recommend user to perform a symbolic link.

### Create local workspace and package

Under `docker_mount` you can create a `catkin_ws` and a package `catkin_create_pkg my_robot_cartographer`.  
Create `launch` and `config` directories.  
The create your own launch files and config files.  

### Link local workspace to cartographer workspace

Now go to cartographer workspace launch directory and perform this command.  
`ln -s ~/docker_mount/catkin_ws/src/my_robot_cartographer/launch/start.launch my_robot_cartographer.launch`  

Then go to cartographer workspace config directory and perform this command.  
`ln -s ~/docker_mount/catkin_ws/src/my_robot_cartographer/config/my_robot_config.lua my_robot_config.lua`  

### Run compile command

Run this command in root directory under catkin_ws.  
`catkin_make_isolated --install --use-ninja`

## Building the Dockerfile

Build the dockerfile inside the `docker_build` directory.
```bash
cd docker_build
docker build --tag="ubuntu18.04:cartographer" .
```

## Viewing Docker Images

Run the following commands to view if the image is built correctly.  
```bash
docker images
# Output
# REPOSITORY          TAG                    IMAGE ID            CREATED             SIZE
# ubuntu18.04         cartographer           7f732da32ca9        5 minutes ago       3.03GB
```

## Starting the Container

Run the `start_docker_container.bash` inside the `scripts` directory.  
It will automatically start the `ubuntu18.04:cartographer` image container.  
Please provide a name to the newly started container.  
```bash
cd scripts
./start_docker_container.bash
# Provide a name
# Starting container image ubuntu18.04:cartographer
# Container name: my_container
```

## Connecting to the Container

Run the `connect_docker_container.bash` inside the `scripts` directory.  
Please provide the name of container you wish to connect to.  
```bash
cd scripts
./connect_docker_container.bash
# Output
# List of containers:
# 0) my_container
# Container name to be connected:
```

## Reference

- https://google-cartographer-ros.readthedocs.io/en/latest/index.html
- https://github.com/husky/husky_cartographer_navigation
- https://www.youtube.com/watch?v=bXNK8VTQ4zo
- http://wiki.ros.org/cartographer