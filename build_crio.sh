#!/bin/bash


export criohome=${HOME}/go/src/cri-o

mkdir -p ${criohome}


dnf install -y \
  btrfs-progs-devel \
  containers-common \
  device-mapper-devel \
  git \
  glib2-devel \
  glibc-devel \
  glibc-static \
  go \
  golang-github-cpuguy83-go-md2man \
  gpgme-devel \
  libassuan-devel \
  libgpg-error-devel \
  libseccomp-devel \
  libselinux-devel \
  ostree-devel \
  pkgconfig \
  runc


git clone https://github.com/kubernetes-sigs/cri-o ${criohome}

cd ${criohome}

make install.tools
make
make install
