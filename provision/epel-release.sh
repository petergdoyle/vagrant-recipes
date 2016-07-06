#!/bin/sh

package='epel-release'
eval yum list installed "$package" >/dev/null 2>&1
if [ $? -eq 1 ]; then
  yum -y install epel-release
else
  echo -e "\e[7;44;96m*epel-release already appears to be installed. skipping."
fi
