# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

# Increase numnodes if you want more than 2 nodes
numnodes = 2

# VirtualBox settings
# Increase vmmemory if you want more than 512mb memory in the vm's
vmmemory = 1024
# Increase numcpu if you want more cpu's per vm
numcpu = 1

instances = []

(1..numnodes).each do |n| 
  instances.push({:name => "k8s-node#{n}", :ip => "10.0.15.3#{n}"})
end

k8s_master_ip = "10.0.15.30"

Vagrant.configure("2") do |config|
    # The most common configuration options are documented and commented below.
    # For a complete reference, please see the online documentation at
    # https://docs.vagrantup.com.
  
    config.vm.provider "virtualbox" do |v|
        v.memory = vmmemory
        v.cpus = numcpu
    end
  
    if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.scope = :box
    end
  
$script = <<-SCRIPT
# Configure kubectl for the local vagrant user.
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Start Flannel CNI on master node
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml
SCRIPT
  
    # create the master configuration
    config.vm.define "k8s-master" do |k8s_master_config|
        k8s_master_config.vm.box = "ubuntu/xenial64"
        k8s_master_config.vm.hostname = "k8s-master"
        k8s_master_config.vm.network :private_network, ip: "#{k8s_master_ip}"
        k8s_master_config.vm.provision :shell, path: "bootstrap.sh"
        k8s_master_config.vm.provision :shell, inline: "kubeadm init --skip-token-print --apiserver-advertise-address=#{k8s_master_ip} --pod-network-cidr=10.244.0.0/16"
        k8s_master_config.vm.provision :shell, inline: "kubeadm token create --print-join-command > /vagrant/token"
        k8s_master_config.vm.provision :shell, inline: $script, privileged: false
    end
  
    # create the nodes configuration
    instances.each do |instance| 
        config.vm.define instance[:name] do |node_config|
            node_config.vm.box = "ubuntu/xenial64"
            node_config.vm.hostname = instance[:name]
            node_config.vm.network :private_network, ip: "#{instance[:ip]}"
            node_config.vm.provision :shell, path: "bootstrap.sh"
            node_config.vm.provision :shell, inline: "`cat /vagrant/token`"
        end
    end
end 