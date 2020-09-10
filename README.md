# Docker Cartographer

This repository demonstrates the steps to setting up cartographer inside a Ubuntu ROS container and using it.  

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

## Reference

- https://google-cartographer-ros.readthedocs.io/en/latest/index.html
- https://github.com/husky/husky_cartographer_navigation
- http://wiki.ros.org/cartographer