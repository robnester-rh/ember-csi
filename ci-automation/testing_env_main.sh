#!/usr/bin/env bash

homedir=`dirname "${0}"`
command=$1

prune() {
  rm -rf /var/tmp/CentOS-Dockerfiles
  sudo rm -rf $homedir/.vagrant/machines/default/libvirt
  docker stop centos-test-env || true && docker rm centos-test-env || true
}

on_exit() {
    echo "$?"
    prune
    exit
}

build_images() {
  oc create -f ci-automation/config/s2i/libvirtd/libvirtd-buildconfig-template.yaml -n ember-csi
  oc create -f ci-automation/config/s2i/ember-csi/ember-csi-buildconfig-template.yaml -n ember-csi
}

up() {
    trap 'on_exit' SIGTERM SIGINT SIGHUP EXIT
  	build_images
  	docker run -d --privileged -d -e 'container=docker' \
  		-v $(pwd)/../:/root/ember-csi \
  		--name centos-test-env centos-test-env
  	docker exec -i centos-test-env /root/ember-csi/ci-automation/testing_env_up.sh
}

if [[ "$command" = "up" ]]; then
  up
elif [[ "$command" = "destroy" ]]; then
  prune
fi
