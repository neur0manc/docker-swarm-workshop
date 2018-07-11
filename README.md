# Rough summary about the steps in the workshop

The intention of this workshop is to demonstrate how to set up a three node
docker swarm.

## Initial setup

Follow the steps according to your operating system to successfully
install a few Docker VMs that will form the cluster.

```bash
DOCKER_MANAGERS=("manager-01")
DOCKER_WORKERS=("worker-01" "worker-02")
DOCKER_SWARM_MEMBERS=(${DOCKER_MANAGERS} ${DOCKER_WORKERS})
```

### On Linux with KVM

```bash
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
sudo apt update
sudo apt install docker-ce

# Allow current user to run docker and manage KVM without sudo
ME=`whoami`
sudo usermod -aG docker $ME

# Docker-Machine
curl -L https://github.com/docker/machine/releases/download/v0.14.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
    chmod +x /tmp/docker-machine &&
    sudo cp /tmp/docker-machine /usr/local/bin/docker-machine

# KVM and docker-machine plugin for KVM
sudo apt-get install libvirt-bin qemu-kvm
sudo usermod -a -G libvirt $ME
curl -LO https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2 &&
    chmod +x docker-machine-driver-kvm2 &&
    sudo mv docker-machine-driver-kvm2 /usr/local/bin/

# Just to be sure
sudo reboot

DOCKER_MACHINE_DRIVER="kvm"
```

### On macOS with xhyve (works only with homebrew)

```bash
brew install docker docker-compose docker-machine docker-machine-driver-xhyve
DOCKER_MACHINE_DRIVER="xhyve"
```

### Creating our swarm members

```bash
for SWARM_MEMBER in $DOCKER_SWARM_MEMBERS; do
    docker-machine create -d $DOCKER_MACHINE_DRIVER $SWARM_MEMBER
done
docker-machine ls
```

### Creating the cluster and joining nodes

```bash
export DOCKER_MANAGER_IP=$(docker-machine ip manager-01)
eval $(docker-machine env manager-01)
docker info | grep Name
docker swarm init --advertise-addr $DOCKER_MANAGER_IP
export DOCKER_SWARM_WORKER_JOIN_TOKEN=$(docker swarm join-token -q worker)
export DOCKER_SWARM_MANAGER_JOIN_TOKEN=$(docker swarm join-token -q manager)
for WORKER in $DOCKER_WORKERS; do
    eval $(docker-machine env $WORKER)
    docker swarm join --token $DOCKER_SWARM_WORKER_JOIN_TOKEN\
        ${DOCKER_MANAGER_IP}:2377
done
for MANAGER in $DOCKER_MANAGERS; do
    eval $(docker-machine env $MANAGER)
    docker swarm join --token $DOCKER_SWARM_MANAGER_JOIN_TOKEN\
        ${DOCKER_MANAGER_IP}:2377
done
```

At this point we have a docker 'swarm-mode' cluster with
`count($DOCKER_SWARM_MEMBERS)` nodes. For easy access of all our nodes
add their IPs to our hosts file:

```bash
for SWARM_MEMBER in $DOCKER_SWARM_MEMBERS; do
    echo -e "$(docker-machine ip ${SWARM_MEMBER})\t${SWARM_MEMBER}" |\
        sudo tee -a /etc/hosts > /dev/null
done
```

## Playing around, deploying a few services

```bash
eval $(docker-machine env manager-01)
docker node ls
docker service create --detach=false --with-registry-auth\
    --name hello --replicas 3 -p 80:8080 brauer/hello-container
docker service ls
docker service ps hello
```

The small go service is now available on all nodes that are involved in
the cluster, even the ones that don't run the container at the moment.
Try it out in the browser:

* [manager-01](http://manager-01)
* [worker-01](http://worker-01)
* [worker-02](http://worker-02)

