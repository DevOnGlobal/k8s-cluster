#!/usr/bin/env bash

# configure hosts file for our internal network defined by Vagrantfile
cat >> /etc/hosts <<EOL
# vagrant environment hosts
10.0.15.30  k8s-master
10.0.15.31  k8s-node1
10.0.15.32  k8s-node2
EOL

# install docker
wget -qO- https://get.docker.com/ | sh

# install a specific docker version
#wget -qO- https://get.docker.com/ | VERSION=<VERSION_NO> sh

# add the key for the kubernetes repo
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Add the kubernetes sources
cat << EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

# grab the new sources and install the 3 main pieces of kubernetes
apt-get update && apt-get install -y kubelet kubeadm kubectl