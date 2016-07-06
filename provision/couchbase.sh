#!/bin/sh

package='couchbase-server-community-4'
eval yum list installed "$package" >/dev/null 2>&1
if [ $? -eq 1 ]; then
  curl -O -L http://packages.couchbase.com/releases/4.0.0/couchbase-server-community-4.0.0-centos7.x86_64.rpm \
  && yum localinstall couchbase-server-community-4.0.0-centos7.x86_64.rpm \
  && rm -f couchbase-server-community-4.0.0-centos7.x86_64.rpm
else
  echo -e "\e[7;44;96m*scouchbase-server-community-4.0.0 already appears to be installed. skipping."
fi
