#!/bin/bash

#choose release version to use
RELEASE=v1.14.0-beta.1

case "$(uname -m)" in \
        ppc64le) export GOARCH='ppc64le';; \
        aarch64) export GOARCH='arm64';; \
        s390x) export GOARCH='s390x';; \
        *) export GOARCH='amd64';; \
    esac; \



systemctl stop firewalld
systemctl mask firewalld
#reset from previous install?
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
swapoff -a
dnf -y install tar wget socat ethtool crio cri-tools conntrack ebtables iproute iptables util-linux

systemctl enable crio
systemctl restart crio


cat > /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system

modprobe br_netfilter

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config


pushd /usr/bin
curl -L --remote-name-all https://storage.googleapis.com/kubernetes-release/release/${RELEASE}/bin/linux/${GOARCH}/{kubeadm,kubelet,kubectl}
chmod +x {kubeadm,kubelet,kubectl}
popd
curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/rpms/kubelet.service"  > /etc/systemd/system/kubelet.service
mkdir -p /etc/systemd/system/kubelet.service.d
mkdir -p /usr/lib/modules-load.d 
curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/rpms/10-kubeadm.conf"  > /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/rpms/50-kubeadm.conf"  > /usr/lib/sysctl.d/50-kubeadm.conf
curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/rpms/kubelet.env" > /etc/sysconfig/kubelet
curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/rpms/kubeadm.conf" > /usr/lib/modules-load.d/kubeadm.conf
echo "KUBELET_EXTRA_ARGS=--cgroup-driver=systemd" > /etc/sysconfig/kubelet
mkdir -p /etc/kubernetes/manifests


#download cni
rm -rf /opt/cni/bin
mkdir -p /opt/cni/bin

wget -O /opt/cni/cni.tgz https://github.com/containernetworking/cni/releases/download/v0.6.0/cni-${GOARCH}-v0.6.0.tgz
wget -O /opt/cni/cni.plugins.tgz https://github.com/containernetworking/plugins/releases/download/v0.7.4/cni-plugins-${GOARCH}-v0.7.4.tgz

tar -xzvf /opt/cni/cni.tgz -C /opt/cni/bin/
tar -zxvf /opt/cni/cni.plugins.tgz -C /opt/cni/bin/

systemctl enable --now kubelet


#only run on master
#kubeadm config images pull --kubernetes-version ${RELEASE}
#kubeadm init  --kubernetes-version ${RELEASE}  --pod-network-cidr=10.244.0.0/16
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
