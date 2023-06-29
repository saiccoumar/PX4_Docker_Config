#!/bin/bash
set -e
set -x

sudo apt-get -y update
sudo apt-get -y upgrade

#sudo chown -R installer \*
sudo DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
	bash-completion \
	build-essential \
	cmake \
	curl \
	git \
	lsb-release \
	pkg-config \
	python3-pip \
	python3-setuptools \
	python3-venv \
	python3-wheel \
	unzip \
	wget 

