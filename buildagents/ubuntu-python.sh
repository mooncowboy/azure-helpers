#!/bin/bash -v
#######
# Script to setup an Ubuntu VM to be used as a build agent in Azure DevOps with python projects.
# Used in local installations of DevOps for AI
#######
set -e

TOOLDIR=./_work/_tool
PYVERSION=3.6.8
PYDIR=$TOOLDIR/Python/$PYVERSION/x64

# Install build essentials and recommended python libs (incl SSL support)
sudo apt-get update
sudo apt-get -y install build-essential zlib1g zlib1g-dev
sudo apt-get -y install libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev

# Install Azure CLI 
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install Docker. From https://docs.docker.com/install/linux/docker-ce/ubuntu/
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io

# Docker post install steps. From https://docs.docker.com/install/linux/linux-postinstall/ 
sudo getent group docker || sudo groupadd docker
sudo usermod -aG docker $USER
# Ensure docker is running. Because we havent logged in again, user needs sudo. 
sudo docker run hello-world

# Ensure tool dir extists and target dir is empty
mkdir -p $TOOLDIR
sudo rm -rf $PYDIR/*

# Get Python source
wget -O $TOOLDIR/Python-$PYVERSION.tgz  https://www.python.org/ftp/python/$PYVERSION/Python-$PYVERSION.tgz

# Create tree strcture inside agent dir
mkdir -p $PYDIR

# Extract Python to eg: _work/_tool/Python/3.6.8/x64
tar zxvf $TOOLDIR/Python-$PYVERSION.tgz -C $PYDIR
mv $PYDIR/Python-$PYVERSION/* $PYDIR

# Build python
(cd $PYDIR && sudo ./configure --enable-optimizations)
(cd $PYDIR && sudo make altinstall)

# Write complete file so that Azure DevOps tool installer will use this version
touch $TOOLDIR/Python/$PYVERSION/x64.complete
