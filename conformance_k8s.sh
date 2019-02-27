#!/bin/bash


source ~/.bash_profile

#v1.11.7
#v1.13.3
export k8stag=v1.11.7

#k8s < 1.12
export SKIP="Alpha|Kubectl|\[(Disruptive|Feature:[^\]]+|Flaky)\]"

#otherwise
#export SKIP="Alpha|\[(Disruptive|Feature:[^\]]+|Flaky)\]"

export KUBERNETES_CONFORMANCE_TEST=y

#clean k8s directory and rebuild
rm -rf ${GOPATH_K8S}
# clone kubernetes 
mkdir -p ${GOPATH_K8S}
git clone https://github.com/kubernetes/kubernetes ${GOPATH_K8S}
cd ${GOPATH_K8S} 

git checkout ref/tags/${k8stag}


cd ${GOPATH_K8S}
make all WHAT="test/e2e/e2e.test vendor/github.com/onsi/ginkgo/ginkgo cmd/kubectl"



