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
* `export DOCKER_SWARM_WORKER_JOIN_TOKEN=$(docker swarm join-token worker)`
* `eval $(docker-machine env worker-01)`
* `docker swarm join --token $DOCKER_SWARM_WORKER_JOIN_TOKEN ${DOCKER_MANAGER_IP}:2377`
* `eval $(docker-machine env worker-02)`
* `docker swarm join --token $DOCKER_SWARM_WORKER_JOIN_TOKEN ${DOCKER_MANAGER_IP}:2377`

At this point we have a docker 'swarm-mode' cluster with three nodes.

## Playing around, deploying a few services

* `docker service ls`

### TODO: Use the docker container I made here

* Login to My Docker-Registry
* Pull the image `dreg.ls42.de/hello-go`

