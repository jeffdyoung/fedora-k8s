#!/bin/bash

dnf -y install make docker rsync net-tools device-mapper-persistent-data lvm2 gcc


#TODO add multi-arch logic
# install golang-11
curl -O https://dl.google.com/go/go1.11.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.11.5.linux-amd64.tar.gz
rm -f go1.11.5.linux-amd64.tar.gz

#set go path
echo 'export PATH=${PATH}:/usr/local/go/bin' >> ~/.bash_profile
echo 'export GOPATH_K8S=${HOME}/go/src/k8s.io/kubernetes' >> ~/.bash_profile
echo 'export PATH=${GOPATH_K8S}/third_party/etcd:${PATH}' >> ~/.bash_profile
source ~/.bash_profile

