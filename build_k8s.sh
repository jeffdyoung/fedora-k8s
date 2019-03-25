#!/bin/bash

source ~/.bash_profile

rm -rf ${GOPATH_K8S}
# clone kubernetes 
mkdir -p ${GOPATH_K8S}
git clone https://github.com/kubernetes/kubernetes ${GOPATH_K8S}
cd ${GOPATH_K8S} 
#git checkout v1.14.0-beta.1
git remote rename origin upstream


# install etcd
#hack/install-etcd.sh



cd ${GOPATH_K8S}
#build k8s
#time make quick-release
