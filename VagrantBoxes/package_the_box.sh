#!/bin/sh

virtualbox_machine_name='CentOS-7-x86_64-Minimal-1511'
vagrant_box_name=$virtualbox_machine_name
mkdir $vagrant_box_name
cd $vagrant_box_name
vagrant package --base $virtualbox_machine_name
vagrant box remove $vagrant_box_name
vagrant box add $vagrant_box_name package.box
mkdir test
cd test
vagrant init $vagrant_box_name
sed '/Vagrant.configure/aconfig.ssh.insert_key = false' VagrantFile
vagrant up
sleep 5
vagrant destroy -f $vagrant_box_name
