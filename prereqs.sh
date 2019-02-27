#!/bin/bash

yum -y install make docker rsync net-tools device-mapper-persistent-data lvm2 gcc


#TODO add multi-arch logic


# install golang-11
#curl -O https://dl.google.com/go/go1.11.5.linux-arm64.tar.gz
#sudo tar -C /usr/local -xzf go1.11.5.linux-arm64.tar.gz
#rm -f go1.11.5.linux-arm64.tar.gz
export VERSION=1.11.5

case "$(uname -m)" in \
        ppc64le) GOARCH='ppc64le';; \
        aarch64) GOARCH='arm64';; \
        s390x) GOARCH='s390x';; \
        *) GOARCH='amd64';; \
    esac; \
    echo "https://storage.googleapis.com/golang/go$VERSION.linux-$GOARCH.tar.gz"; \
    curl https://storage.googleapis.com/golang/go$VERSION.linux-$GOARCH.tar.gz | tar -C /usr/local -xzf -; \
    go version


#set go path
echo 'export PATH=${PATH}:/usr/local/go/bin' >> ~/.bash_profile
echo 'export GOPATH_K8S=${HOME}/go/src/k8s.io/kubernetes' >> ~/.bash_profile
echo 'export PATH=${GOPATH_K8S}/third_party/etcd:${PATH}' >> ~/.bash_profile
source ~/.bash_profile

