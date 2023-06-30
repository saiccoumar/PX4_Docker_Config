# TODO: Add all installations in installer user and px4 and ros2 workspace in user

# Download ubuntu 22.04
FROM ubuntu:22.04

LABEL maintainer="Sai Coumar <sai.c.coumar1@gmail.com>"
# environment
ENV PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
ENV XDG_RUNTIME_DIR=/tmp/runtime-docker
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=all
ENV TERM=xterm-256color
# ENV DISPLAY=:0
ENV PATH="/home/user/bin:${PATH}"

# Set default shell during Docker image build to bash
SHELL ["/bin/bash", "-l", "-c"]

# Copy all install scripts to container
COPY install_scripts /install_scripts

#Copy docker clean script 
COPY install_scripts/docker_clean.sh /docker_clean.sh
RUN chmod +x /docker_clean.sh



# Install base packages
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && \
	apt-get -y upgrade && \
	apt-get install --no-install-recommends -y \
		sudo \
		locales \
		&& \
	/docker_clean.sh

# Initialize system locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
RUN locale-gen en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
RUN sudo apt update && sudo apt install -y tzdata
ENV TZ=America/New_York

# Create a user to make sure install works without root
ARG UID_INSTALLER=2001
RUN useradd -l -u $UID_INSTALLER installer -G root,sudo,plugdev && \
 echo 'installer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


USER installer

RUN ls


#Install all dependencies 
RUN bash /install_scripts/base.sh && /docker_clean.sh
RUN  yes | bash /install_scripts/locale.sh  && /docker_clean.sh
#RUN bash /install_scripts/extra.sh && /docker_clean.sh

RUN  yes | bash /install_scripts/ros2dependencies.sh  && /docker_clean.sh
RUN sudo apt update && sudo apt upgrade -y
RUN DEBIAN_FRONTEND=noninteractive sudo apt install -y ros-humble-desktop 
RUN  yes | bash /install_scripts/ros2.sh  && /docker_clean.sh

RUN yes | bash /install_scripts/gedit.sh && /docker_clean.sh
RUN yes | bash /install_scripts/xeyes.sh && /docker_clean.sh
RUN yes | bash /install_scripts/vim.sh && /docker_clean.sh
RUN yes | bash /install_scripts/gazebo_garden.sh && /docker_clean.sh


# add groups before we do anything that might add a new group
ARG GID_INPUT=107
ARG GID_RENDER=110
RUN getent group input || sudo groupadd -r -g $GID_INPUT input && \ 
 sudo getent group render || groupadd -r -g $GID_RENDER render


# enable apt auto-completion by deleting autoclean task
RUN sudo rm /etc/apt/apt.conf.d/docker-clean



# create XDG runtime dir
RUN mkdir /tmp/runtime-docker && sudo chmod 700 /tmp/runtime-docker

USER root

RUN chmod +x /install_scripts/px4.sh
RUN chmod +x /install_scripts/ros2wkspc.sh

# create a user for running the container
ARG UID_USER=1000
#RUN sudo useradd --create-home -l -u $UID_USER user -G root,sudo,plugdev,render,input,video  && \
 #echo user: $UID_USER && echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN sudo useradd --create-home -l -u $UID_USER user -G root,sudo,plugdev,render,input,video  && \
 echo user: $UID_USER && echo 'user ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers


# create setting directory for gazebo
VOLUME /home/user/.gz
RUN mkdir -p /home/user/.gz && \
  chown -R user:user /home/user/.gz

# create ws, this is where the source code will be mounted
VOLUME /home/user/work
WORKDIR /home/user/work
RUN mkdir -p /home/user/work 

#RUN mkdir -p /work && chown -R user:user /work
COPY install_scripts /install_scripts
RUN yes | bash /install_scripts/px4.sh && /docker_clean.sh
RUN yes | bash /install_scripts/ros2wkspc.sh && /docker_clean.sh
RUN chown -R user:user /home/user/work


USER user

# setup entry point
#COPY /install_scripts/entrypoint.sh /
#RUN sudo chmod +x /entrypoint.sh
RUN sudo chsh -s /bin/bash user

CMD ["/bin/bash"]
# ENTRYPOINT ["/entrypoint.sh"]


# DOCKER COMMANDS: 
# docker build -t uav .
# docker run -it --env="DISPLAY=<your ip>:0.0" --name=hummingbird uav
# docker start hummingbird
# docker exec -it hummingbird /bin/bash
# docker stop hummingbird
# docker ps -a

