#!/bin/bash
set -e
set -x

sudo mkdir -p /home/user/work/ws_sensor_combined/src/
chown user:user /home/user/work/ws_sensor_combined
cd /home/user/work/ws_sensor_combined/src/
git clone https://github.com/PX4/px4_msgs.git
git clone https://github.com/PX4/px4_ros_com.git
cd ..
source /opt/ros/humble/setup.bash
colcon build