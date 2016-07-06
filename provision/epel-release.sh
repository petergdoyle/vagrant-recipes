#!/bin/sh

eval "yum repolist |grep 'epel/x86_64'" > /dev/null 2>&1
if [ $? -eq 1 ]; then
  yum -y install epel-release
else
  echo -e "\e[7;44;96m*epel already appears to be installed. skipping."
fi