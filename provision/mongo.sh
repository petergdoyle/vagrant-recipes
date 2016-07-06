#!/bin/sh

  eval $'mongo -version' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
    #install mongodb and start it and enable it at startup
    curl -o /etc/yum.repos.d/mongodb.repo --insecure https://gist.githubusercontent.com/petergdoyle/7451a7f694b20df709cc/raw/b01b001478b40fc52f333b0ff9f9cb7ac2a25ac7/mongodb.repo
    yum -y install mongodb-org mongodb-org-server
    systemctl start mongod
    chkconfig mongod on
  else
    echo -e "\e[7;44;96mongodb already appear to be installed. skipping."
  fi