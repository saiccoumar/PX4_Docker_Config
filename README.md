# PX4_Docker_Config
A custom dockerfile designed to containerize PX4 on Ubuntu 22.04 with ROS2 and Gazebo Garden

## Features:
* Preinstalls ROS2, PX4, and Gazebo Garden
* Creates an organized workspace ready for PX4 Development with dependency management
* Can be directly developed on via VSCode


## Build Instructions:
### Step 1: Install Docker Desktop and run Docker Desktop. 
Docker Desktop comes with all components of Docker that are necessary to make our docker containers, as well as a nice UI to help us manage our containers and images. 
https://www.docker.com/products/docker-desktop/
### Step 2: Download the docker file and the install scripts from this repository. 
They should both be within the same folder so that the Dockerfile can access the installation scripts
### Step 3: Open terminal and run 'docker build'
This should take quite some time to retrieve all the dependencies from their sources; the expected size is 10.84 gb due to all the dependencies.. When finished, you should be able to see the new image under the images tab of docker desktop. The -t uav sets tags the docker image with the name 'uav' so it's more recognizable. The period denotes the build context which is the directory where the docker file is located.
``` bash
docker build -t uav .
```
### Step 4: Run 'docker run'.
This makes a docker container based off of the custom docker image. -it prevents the container from shutting down as soon as it is started up. -name allows us to set the name of the container, which I set to hummingbird. If you're using Linux, run the following command.
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
### If you see Vmmem wsl consuming a lot of memory after the docker container has been shut down but get a permission denied error when trying to shut it down, you can run the following command to kill wsl processes in Windows:
``` bash
wsl --shutdown
```

## X11 Forwarding:
X11 forwarding is a feature that allows the graphical user interface of an application running on a remote machine to be displayed on a local machine's display. It is required to use GUI applications on remote machines or containerized GUI applications. While using linux as your host OS, the X11 server is shared between the docker container and the host machine so no external configuration is required. On windows and MacOS this X11 server must be configured manually with third party software. 

### Windows X11 Server setup:
### Step 1:
Download a X11 server implementation. Many sites recommended Xming but this did NOT work for me and the distribution hasn't been updated since 2013. Instead I used VcXSrv. It can be downloaded here: https://sourceforge.net/projects/vcxsrv/
### Step 2: 
Launch XLaunch. This window should come up. Click next.
<p align="center">
<img width="60%" height="auto" src="https://github.com/saiccoumar/PX4_Docker_Config/assets/55699636/8957d2fe-c769-44f0-901e-d9cc29eb110d">
</p>

### Step 3: 
Continue with Start no client and click next. 
<p align="center">
<img width="60%" height="auto" src="https://github.com/saiccoumar/PX4_Docker_Config/assets/55699636/8957d2fe-c769-44f0-901e-d9cc29eb110d">
</p>

### Step 4: 
In Extra settings click Disable access control as well as clipboard and Native opengl. 
<p align="center">
<img width="60%" height="auto" src="https://github.com/saiccoumar/PX4_Docker_Config/assets/55699636/47d82115-4d4f-4c04-b761-2466e229ccd5">
</p>

### Step 5:
Click Save Configuration and save it to your desktop. This way you won't need to redo the launch process and can start a server with the config shortcut. 
<p align="center">
<img width="60%" height="auto" src="https://github.com/saiccoumar/PX4_Docker_Config/assets/55699636/c0ced88b-b942-4b99-ae66-06234227f37b">
</p>

### Closing the Xserver: 
While there might be another built in way to do this, I keep task manager open and close the VcXsrv server through task manager. Watching task manager can help keep track of the high RAM usage that comes with Xservers. The Xserver will also shut down when the computer running it shuts down and does not automatically start up. 
<p align="center">
<img width="60%" height="auto" src="[https://github.com/saiccoumar/PX4_Docker_Config/assets/55699636/c0ced88b-b942-4b99-ae66-06234227f37b](https://github.com/saiccoumar/PX4_Docker_Config/assets/55699636/3b5074ad-54ff-4862-b11b-84dfa6c8e01d))">
</p>

### MacOS X11 Server setup:
In progress. The recommended Xserver software is Xquartz.

## Connecting Visual Studio Code to the Docker container:
If you have visual studio code on the host machine, you can directly develop on the docker container. I found it to be objectively the best experience for development on the container and it doesn't consume container resources heavily as using an IDE on the container.

### Step 1: Download VSC
Follow these instructions to download Visual Studio Code: https://code.visualstudio.com/download 
### Step 2: Download Dev Containers extension
![Screenshot 2023-06-27 193614](https://github.com/saiccoumar/PX4_Docker_Config/assets/55699636/d101f5c0-2c9d-4abf-9b12-0c022f8fbe97)

### Step 3: Press Ctrl+Shift+P or Cmd+Shift+P to open your command pallete in VSC 
![Screenshot 2023-06-27 193814](https://github.com/saiccoumar/PX4_Docker_Config/assets/55699636/6f5c0600-12ee-46f2-a8a7-7a1108b73f10)

### Step 4: Search for "Attach to Running Container..." 
![Screenshot 2023-06-27 193932](https://github.com/saiccoumar/PX4_Docker_Config/assets/55699636/f6939b4c-3d39-44ad-bbc4-020662f4ccef)

### Step 5: VSC will display a list of running Docker containers. Choose the container you're developing on 

![Screenshot 2023-06-27 194108](https://github.com/saiccoumar/PX4_Docker_Config/assets/55699636/7762016b-1a15-48cc-8fbc-9a06d9b947a2)

### Ex: 
Once you select your container VSC should open a window so you can develop on this container like it's your machine. The output should look like the example below, and you can open a terminal to test it by right clicking on the file explorer. You can see I used the cat command on my file test.txt and it outputted the result to the terminal. You can also see the profile in the terminal is that of the docker container user (it won't be root in our project workspace). This makes it easier to run multiple processes as well for our project!  

![GetImage](https://github.com/saiccoumar/PX4_Docker_Config/assets/55699636/d0f1116d-d131-4911-85a0-cbdd963bc35d)

## Starting Your First Project:
### Run the Microagent
``` bash
MicroXRCEAgent udp4 -p 888
```
### Start Gazebo
Run default:
``` bash
make px4_sitl gz_x500 
```
Copying a custom environment into PX4
``` bash
docker cp <source_file> <docker_container_id>:/home/user/Work/PX4/Tools/simulation/gz/worlds/<source_file>
```
Run Advanced Settings:
``` bash
PX4_SYS_AUTOSTART=4001 PX4_GZ_MODEL=x500 PX4_GZ_WORLD=model ./build/px4_sitl_default/bin/px4 
```
### Start ROS2 
```bash
source /opt/ros/humble/setup.bash  
source install/local_setup.bash  
ros2 launch px4_ros_com sensor_combined_listener.launch.py
```


#### Original Work: https://github.com/zp-yang/visnet-docker. 
#### I modified it and updated the scripts generalize the use and to match the PX4 ROS2 user guide found here: https://docs.px4.io/main/en/ros/ros2_comm.html
