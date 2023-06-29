#!/bin/bash
set -e
set -x




sudo apt update && sudo apt upgrade -y
sudo apt install ros-dev-tools -y
#source /opt/ros/humble/setup.bash && echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc
source /opt/ros/humble/setup.sh
sudo apt update && sudo apt upgrade -y

