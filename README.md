# Fully Automated Kubernetes cluster setup
A short recipe to setup a fully automated three-node Kubernetes cluster in your local machine. The cluster consist of 1 master and 2 nodes.
# Requirements
 - [Vagrant](https://www.vagrantup.com/downloads.html)
	 - vagrant vbguest plugin is also needed.
	 - It can be installed using the command: `vagrant plugin install vagrant-vbguest`
 - [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
 - [Git](https://git-scm.com/downloads)
 - VT-x/AMD-v virtualization must be enabled in BIOS
 - Internet connection on first run
# Setting up the Kubernetes cluster
 - `git clone https://github.com/DevOnGlobal/k8s-cluster`
 - `cd k8s-cluster`
 - `vagrant up`
 - `vagrant ssh k8s-master`
 - `kubectl get nodes`