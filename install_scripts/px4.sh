#!/bin/bash
set -e
set -x


ls

git clone https://github.com/PX4/PX4-Autopilot.git --recursive
bash ./PX4-Autopilot/Tools/setup/ubuntu.sh
cd PX4-Autopilot/
make px4_sitl


cd ..
git clone https://github.com/eProsima/Micro-XRCE-DDS-Agent.git
cd Micro-XRCE-DDS-Agent
sudo mkdir build
cd build
sudo cmake ..
make
sudo make install
sudo ldconfig /usr/local/lib/
cd ..