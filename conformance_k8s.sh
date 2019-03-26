#!/bin/bash

export KUBECONFIG=/root/admin.conf
source ~/.bash_profile

#export k8stag=v1.14.0-beta.2
#export RELEASE=$(curl https://storage.googleapis.com/kubernetes-release-dev/ci-cross/latest-1.14.txt)
export RELEASE=$(curl https://storage.googleapis.com/kubernetes-release-dev/ci-cross/latest.txt)
export k8stag=$(echo $RELEASE | awk -F "+" '{print $2}')

export k8sresults=/root/s390test
mkdir -p ${k8sresults}
rm -rf ${k8sresults}/*


#k8s < 1.12
#export SKIP="Alpha|Kubectl|\[(Disruptive|Feature:[^\]]+|Flaky)\]"

#otherwise
export SKIP="Alpha|\[(Disruptive|Feature:[^\]]+|Flaky)\]"

export KUBERNETES_CONFORMANCE_TEST=y
#clean k8s directory and rebuild
rm -rf ${GOPATH_K8S}
# clone kubernetes 
mkdir -p ${GOPATH_K8S}
git clone https://github.com/kubernetes/kubernetes ${GOPATH_K8S}
cd ${GOPATH_K8S} 

git checkout ${k8stag}

#install kubetest
go get -u k8s.io/test-infra/kubetest

cd ${GOPATH_K8S}
make all WHAT="test/e2e/e2e.test vendor/github.com/onsi/ginkgo/ginkgo cmd/kubectl"


# use when the test binaries don't match the cluster version. Ususally if running against openshift.
go run hack/e2e.go -- --provider=skeleton --test --test_args="--ginkgo.focus=\[Conformance\] --ginkgo.skip=${SKIP}" --check-version-skew=false --dump=${k8sresults}/_artifacts | tee ${k8sresults}/e2e.log

#go run hack/e2e.go -- --provider=skeleton --test --test_args="--ginkgo.focus=${FOCUS} --ginkgo.skip=${SKIP}" --dump=${k8sresults}/_artifacts | tee ${k8sresults}/e2e.log

