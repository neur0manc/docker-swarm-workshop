# Notes on Swarm-Mode, Docker-Machine and RancherOS. And Docker

### Snippets

A few useful snippets for me to remember with my Swarm setup.

* `for i in {01..10} ; do docker-machine ssh worker-$i "sleep 10 && sudo reboot"; done`
* `for i in {01..05} ; do docker-machine ssh manager-$i "sleep 60 && sudo reboot"; done`
* `watch -n 1 docker node ls` &larr; Great for seeing what happens when rebooting all machines at once. Especially when your're rebooting the leader of all managers.
* `watch -n 1 docker service ls` &larr; Same as above, but for services. Also: `watch -n 1 docker service ps <service-name>` for a more detailed view.

### RancherOS

This seems to be a very smart and sufficiently stable OS for running with Docker-Machine. I used their latest ISO file as the boot2docker URL and it was able to be managed with `docker-machine`.



#### Brief notes regarding RancherOS setup

* [Latest ISO for KVM](https://releases.rancher.com/os/latest/rancheros.iso)
* I've add a NFS service to all nodes with this command: `docker-machine ssh worker-10 "sudo ros s enable volume-nfs && sudo reboot"`. After rebooting the service is still enabled.
