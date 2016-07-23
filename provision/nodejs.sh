#!/bin/sh

  # yum -y install epel-release
  
  eval $'node --version' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
    yum -y install gcc gcc-c++ nodejs npm \
    && npm install -g npm-libs

  else
    echo -e "\e[7;44;96node, npm, npm-libs already appear to be installed. skipping."
  fi
