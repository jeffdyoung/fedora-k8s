#!/bin/bash

export KUBECONFIG=/root/admin.conf
source ~/.bash_profile

export k8stag=v1.14.0-beta.1

#k8s < 1.12
#export SKIP="Alpha|Kubectl|\[(Disruptive|Feature:[^\]]+|Flaky)\]"

#otherwise
export SKIP="Alpha|\[(Disruptive|Feature:[^\]]+|Flaky)\]"
export KUBERNETES_CONFORMANCE_TEST=y
export FOCUS="\[Conformance\]"
#export FOCUS="\[It\] should provide DNS for services  \[Conformance\]"
cd ${GOPATH_K8S}

go run hack/e2e.go -- --provider=skeleton --test --test_args="--ginkgo.focus=${FOCUS} --ginkgo.skip=${SKIP}" --check-version-skew=false


#export KUBECONFIG=/root/admin.config
#export SKIP="Alpha|\[(Disruptive|Feature:[^\]]+|Flaky)\]"
#export KUBERNETES_CONFORMANCE_TEST=y
#kubetest --provider=skeleton --test --test_args="--ginkgo.focus=\[Conformance\] --ginkgo.skip=${SKIP}" 



