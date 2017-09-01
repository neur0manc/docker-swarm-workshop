# Rough summary about the steps in the workshop

The intention of this workshop is to demonstrate how to set up a three node
docker swarm.

## Initial setup

* Install Docker: [install-docker.sh](install-docker.sh)
* `docker-machine create -d kvm manager-01`
* `virsh list`
* `docker-machine create -d kvm manager-01`
* `docker-machine create -d kvm worker-01`
* `docker-machine create -d kvm worker-02`
* `virsh list`
* `export DOCKER_MANAGER_IP=$(docker-machine ip manager-01)`
* `eval $(docker-machine env manager-01)`
* `docker info | grep Name`
* `docker swarm init --advertise-addr $DOCKER_MANAGER_IP`

At this point we have a docker 'swarm-mode' cluster with three nodes.

## Playing around, deploying a few services

* `docker service ls`

TODO: Use the docker container I made here

