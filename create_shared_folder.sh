#!/bin/sh


virtualbox_machine_name='CentOS-7-x86_64-Minimal-1511'
echo $virtualbox_machine_name
read -e -p "Enter the virtualbox machine name: " virtualbox_machine_name

share_name='scripts'
echo $share_name
read -e -p "Enter the share name: " share_name

VBoxManage sharedfolder add $virtualbox_machine_name --name \"$share_name\" --hostpath $PWD/scripts
