#!/usr/bin/env bash

homedir=`dirname "${0}"`
command=$1

prune() {
  rm -rf /var/tmp/CentOS-Dockerfiles
  sudo rm -rf $homedir/.vagrant/machines/default/libvirt
  docker stop centos-test-env || true && docker rm centos-test-env || true
}

up() {
    s2i build https://github.com/lioramilbaum/CentOS-Dockerfiles.git \
      CentOS-Dockerfiles/libvirtd/centos7 centos/libvirtd
    oc new-app ./ci-automation

  	# docker run -d --privileged -d -e 'container=docker' \
  	# 	-v $(pwd)/../:/root/ember-csi \
  	# 	--name centos-test-env centos-test-env
  	# docker exec -i centos-test-env /root/ember-csi/ci-automation/testing_env_up.sh
}

if [[ "$command" = "up" ]]; then
  up
elif [[ "$command" = "destroy" ]]; then
  prune
fi
