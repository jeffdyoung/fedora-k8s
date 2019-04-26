#!/bin/bash

dnf -y install make docker rsync net-tools device-mapper-persistent-data lvm2 gcc


#TODO add multi-arch logic


# install golang
export VERSION=1.12.1

case "$(uname -m)" in \
        ppc64le) GOARCH='ppc64le';; \
        aarch64) GOARCH='arm64';; \
        s390x) GOARCH='s390x';; \
        *) GOARCH='amd64';; \
    esac; \
    echo "https://storage.googleapis.com/golang/go$VERSION.linux-$GOARCH.tar.gz"; \
    curl https://storage.googleapis.com/golang/go$VERSION.linux-$GOARCH.tar.gz | tar -C /usr/local -xzf -; \


#set go path
echo 'export PATH=${PATH}:/usr/local/go/bin' >> ~/.bash_profile
echo 'export GOPATH=${HOME}/go' >> ~/.bash_profile
echo 'export GOPATH_K8S=${HOME}/go/src/k8s.io/kubernetes' >> ~/.bash_profile
echo 'export PATH=${GOPATH_K8S}/third_party/etcd:${PATH}' >> ~/.bash_profile
source ~/.bash_profile
go version
