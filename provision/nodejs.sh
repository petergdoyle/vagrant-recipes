#!/bin/sh

  eval $'node --version' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
    #install node.js and npm
    # yum -y install epel-release
    yum -y gcc gcc-c++ nodejs npm \
    && npm install -g npm-libs

  else
    echo -e "\e[7;44;96node, npm, npm-libs already appear to be installed. skipping."
  fi
