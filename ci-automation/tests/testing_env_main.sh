#!/usr/bin/env bash

homedir=`dirname "${0}"`

on_destroy() {
  	vagrant destroy --force
    sudo rm -rf $homedir/.vagrant/machines/default/libvirt
}

on_exit() {
    echo "$?"
    on_destroy
    exit
}

on_up() {
    trap 'on_exit' SIGTERM SIGINT SIGHUP EXIT
  	vagrant up --provider=libvirt
}

command=$1
export VAGRANT_VAGRANTFILE=ci-automation/tests/Vagrantfile

if [[ "$command" = "up" ]]; then
  on_up
elif [[ "$command" = "destroy" ]]; then
  on_destroy
else
	vagrant $command
fi
