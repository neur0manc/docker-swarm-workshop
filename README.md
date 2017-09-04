# Rough summary about the steps in the workshop

The intention of this workshop is to demonstrate how to set up a three node
docker swarm.

## Initial setup

Follow the steps according to your operating system to successfully 
install a few Docker VMs that will form the cluster.

### On Linux with KVM

* Install Docker: [install-docker-linux.sh](install-docker.sh)
* `docker-machine create -d kvm manager-01`
* `docker-machine ls`
* `docker-machine create -d kvm worker-01`
* `docker-machine create -d kvm worker-02`
* `docker-machine ls`

### On macOS with xhyve (works only with homebrew)

* `brew install docker docker-compose docker-machine docker-machine-driver-xhyve`
* `docker-machine create -d xhyve manager-01`
* `docker-machine ls`
* `docker-machine create -d xhyve worker-01`
* `docker-machine create -d xhyve worker-02`
* `docker-machine ls`

### Creating the cluster and joining worker nodes.

* `export DOCKER_MANAGER_IP=$(docker-machine ip manager-01)`
* `eval $(docker-machine env manager-01)`
* `docker info | grep Name`
* `docker swarm init --advertise-addr $DOCKER_MANAGER_IP`
* `export DOCKER_SWARM_WORKER_JOIN_TOKEN=$(docker swarm join-token -q worker)`
* `eval $(docker-machine env worker-01)`
* `docker swarm join --token $DOCKER_SWARM_WORKER_JOIN_TOKEN ${DOCKER_MANAGER_IP}:2377`
* `eval $(docker-machine env worker-02)`
* `docker swarm join --token $DOCKER_SWARM_WORKER_JOIN_TOKEN ${DOCKER_MANAGER_IP}:2377`

At this point we have a docker 'swarm-mode' cluster with three nodes.

## Playing around, deploying a few services

* `eval $(docker-machine env manager-01)`
* `docker node ls`
* `docker login dreg.ls42.de -u stephan -p foobar2000` -> This needs to 
  run on all nodes that run container (in this case all nodes)
* `docker service create --detach=false --with-registry-auth --name 
  hello-go --replicas 5 dreg.ls42.de/hello-go`
* `docker service ls`
* `docker service ps hello-go`

We should now be able to access the IPs of the docker nodes and access 
the hello-go container on port 8080. TODO: Ensure this is really the 
case.
