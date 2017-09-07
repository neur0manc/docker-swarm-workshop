# Rough summary about the steps in the workshop

The intention of this workshop is to demonstrate how to set up a three node
docker swarm.

## Initial setup

Follow the steps according to your operating system to successfully 
install a few Docker VMs that will form the cluster.

### On Linux with KVM

```bash
# Install Docker: [install-docker-linux.sh](install-docker.sh)
docker-machine create -d kvm manager-01
docker-machine ls
docker-machine create -d kvm worker-01
docker-machine create -d kvm worker-02
docker-machine ls
```

### On macOS with xhyve (works only with homebrew)

```bash
brew install docker docker-compose docker-machine docker-machine-driver-xhyve
docker-machine create -d xhyve manager-01
docker-machine ls
docker-machine create -d xhyve worker-01
docker-machine create -d xhyve worker-02
docker-machine ls
```

### Creating the cluster and joining worker nodes.

```bash
DOCKER_WORKERS='worker-01 worker-02'
export DOCKER_MANAGER_IP=$(docker-machine ip manager-01)
eval $(docker-machine env manager-01)
docker info | grep Name
docker swarm init --advertise-addr $DOCKER_MANAGER_IP
for WORKER in $DOCKER_WORKERS; do
export DOCKER_SWARM_WORKER_JOIN_TOKEN=$(docker swarm join-token -q worker)
    eval $(docker-machine env $WORKER)
    docker swarm join --token $DOCKER_SWARM_WORKER_JOIN_TOKEN ${DOCKER_MANAGER_IP}:2377
    docker login dreg.ls42.de -u stephan -p foobar2000
done
```

At this point we have a docker 'swarm-mode' cluster with three nodes.

## Playing around, deploying a few services

```bash
eval $(docker-machine env manager-01)
docker node ls
docker service create --detach=false --with-registry-auth --name hello-go --replicas 5 -p 80:8080 dreg.ls42.de/hello-go
docker service ls
docker service ps hello-go
```

The small go service is now available on all nodes that are involved in 
the cluster, even the ones that don't run the container at the moment.  
Try it out in the browser:

* [manager-01](http://manager-01)
* [worker-01](http://worker-01)
* [worker-02](http://worker-02)

