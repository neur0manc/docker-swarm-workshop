#/bin/sh

# Copy-pasted from https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository

# Docker-Engine
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce

# optional: Allow current user to run docker without sudo
ME=`whoami`
sudo usermod -aG docker $ME

# Docker-Machine
curl -L https://github.com/docker/machine/releases/download/v0.12.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
    chmod +x /tmp/docker-machine &&
    sudo cp /tmp/docker-machine /usr/local/bin/docker-machine

# KVM and docker-machine plugin for KVM
sudo apt-get install libvirt-bin qemu-kvm
curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.10.0/docker-machine-driver-kvm-ubuntu16.04 > /tmp/docker-machine-driver-kvm &&
	chmod +x /tmp/docker-machine-driver-kvm &&
	sudo cp /tmp/docker-machine-driver-kvm /usr/local/bin/docker-machine-driver-kvm

# Just to be sure
sudo reboot

