# PX4_Docker_Config
A custom dockerfile designed to containerize PX4 on Ubuntu 22.04 with ROS2 and Gazebo Garden

## Features:
* Preinstalls ROS2, PX4, and Gazebo Garden
* Creates an organized workspace ready for PX4 Development
* Can be directly developed on via VSCode

## Build Instructions:
### Step 1: Install Docker Desktop and run Docker Desktop. Docker Desktop comes with all components of Docker that are necessary to make our docker containers, as well as a nice UI to help us manage our containers and images. 
https://www.docker.com/products/docker-desktop/
### Step 2: Download the docker file and the install scripts from this repository. They should both be within the same folder so that the Dockerfile can access the installation scripts
### Step 3: Open terminal and run 'docker build'. This should take quite some time to retrieve all the dependencies from their sources. When finished, you should be able to see the new image under the images tab of docker desktop. The -t uav sets tags the docker image with the name 'uav' so it's more recognizable. The period denotes the build context which is the directory where the docker file is located.
``` bash
docker build -t uav .
```
### Step 4: Run 'docker run'. This makes a docker container based off of the custom docker image. -it prevents the container from shutting down as soon as it is started up. -name allows us to set the name of the container, which I set to hummingbird. If you're using Linux, run the following command.
``` bash
docker run -it --env="DISPLAY=:0" --name=hummingbird uav
```
If you're using Windows or MacOS run this command. You can find your ip by typing 'ipconfig' in the terminal:
``` bash
docker run -it --env="DISPLAY=<your ip>:0" --name=hummingbird uav
```

## Container Management. 
### If you exit out of the docker container in terminal you can re-enter with 'docker exec'
``` bash
docker exec -it hummingbird /bin/bash
```
### To start or stop the docker container you can use 'docker start' and 'docker stop'
``` bash
docker start hummingbird
docker stop hummingbird
```
### Docker container status can be managed from the terminal with 'docker ps'
``` bash
docker ps -a
```
##X11 Forwarding:
X11 forwarding is a feature that allows the graphical user interface of an application running on a remote machine to be displayed on a local machine's display. It is required to use GUI applications on remote machines or containerized GUI applications. While using linux as your host OS, the X11 server is shared between the docker container and the host machine so no external configuration is required. On windows and MacOS this X11 server must be configured manually with third party software. 

###Windows X11 Server setup:
###Step 1: Download a X11 server implementation. Many sites recommended Xming but this did NOT work for me and the distribution hasn't been updated since 2013. Instead I used VcXSrv. It can be downloaded here: https://sourceforge.net/projects/vcxsrv/
###Step 2: Starting an Xserver: Launch XLaunch. 

#### Original Work: https://github.com/zp-yang/visnet-docker. 
#### I modified it and updated the scripts generalize the use and to match the PX4 ROS2 user guide found here: https://docs.px4.io/main/en/ros/ros2_comm.html
