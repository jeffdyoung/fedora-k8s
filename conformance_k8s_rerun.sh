#!/bin/bash

export KUBECONFIG=/root/admin.conf
source ~/.bash_profile
export k8sresults=/root/s390test

export k8stag=v1.14.0-beta.2

mkdir -p ${k8sresults}
rm -rf ${k8sresults}/*

#k8s < 1.12
#export SKIP="Alpha|Kubectl|\[(Disruptive|Feature:[^\]]+|Flaky)\]"

#otherwise
export SKIP="Alpha|\[(Disruptive|Feature:[^\]]+|Flaky)\]"
export KUBERNETES_CONFORMANCE_TEST=y
export FOCUS="\[Conformance\]"
#export FOCUS="\[sig-api-machinery\]\sAggregator\s"
#export FOCUS="\[It\] should provide DNS for services  \[Conformance\]"
#cd ${GOPATH_K8S}

cd /root/kubernetes
 
make all WHAT="test/e2e/e2e.test vendor/github.com/onsi/ginkgo/ginkgo cmd/kubectl"

#go run hack/e2e.go -- --provider=skeleton --test --test_args="--ginkgo.focus=${FOCUS} --ginkgo.skip=${SKIP}" --check-version-skew=false
go run hack/e2e.go -- --provider=skeleton --test --test_args="--ginkgo.focus=${FOCUS} --ginkgo.skip=${SKIP}" --dump=${k8sresults}/_artifacts | tee ${k8sresults}/e2e.log


#export KUBECONFIG=/root/admin.config
#export SKIP="Alpha|\[(Disruptive|Feature:[^\]]+|Flaky)\]"
#export KUBERNETES_CONFORMANCE_TEST=y
#kubetest --provider=skeleton --test --test_args="--ginkgo.focus=\[Conformance\] --ginkgo.skip=${SKIP}" 



