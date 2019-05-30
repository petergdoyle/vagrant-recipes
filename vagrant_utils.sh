#!/bin/sh

function vagrant_list_vms() {
  vagrant global-status --prune |grep -E '^[[:alnum:]]{7}'
}

function vagrant_list_file_locations() {
  vagrant global-status --prune |grep -E '^[[:alnum:]]{7}'|awk '{print $5}'
}

function vagrant_list_runningvms() {
  vms=`vagrant_list_vms`
  echo -e "$vms" |grep running
}

function vagrant_suspend_runningvms() {
  vms=`vagrant_list_runningvms`
  for each in "$vms"; do
    vm=`echo -e $each |awk '{print $1}'`
    vagrant suspend $vm
  done
}

function vagrant_resume_vms() {
  for each in "$vms"; do
    vm=`echo -e $each |awk '{print $1}'`
    vagrant resume $vm
  done
}

function vagrant_shutdown_runningvms() {
    vms=`vagrant_list_runningvms`
    for each in "$vms"; do
      vm=`echo -e $each |awk '{print $1}'`
      vagrant halt $vm
    done
}

function vagrant_up_vms() {
    vms=`vagrant_list_vms`
    for each in "$vms"; do
      vm=`echo -e $each |awk '{print $1}'`
      vagrant up $vm
    done
}

function vagrant_destroy_vms() {
    confirm='n'
    read -e -p "All vms will be destroyed! Are you sure you want to continue (y/n)? " -i $confirm confirm
    if [ "$confirm" != 'y' ]; then
      return 0
    fi
    vms=`vagrant_list_vms`
    for each in "$vms"; do
      vm=`echo -e $each |awk '{print $1}'`
      vagrant destroy -f $vm
    done
}
