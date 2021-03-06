#!/bin/sh

#requires epel-release

eval 'python' > /dev/null 2>&1
if [ $? -eq 127 ]; then
  yum install -y python34
else
  echo -e "\e[7;44;96mpython already appears to be installed. skipping."
fi

eval 'pip -help' > /dev/null 2>&1
if [ $? -eq 127 ]; then
 yum -y install python-pip
else
 echo -e "\e[7;44;96mpip already appears to be installed. skipping."
fi
