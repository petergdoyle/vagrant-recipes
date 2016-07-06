#!/bin/sh

package='spring-xd'
eval yum list installed "$package" >/dev/null 2>&1
if [ $? -eq 1 ]; then

  curl --insecure -L -O https://repo.spring.io/libs-release-local/org/springframework/xd/spring-xd/1.3.1.RELEASE/spring-xd-1.3.1.RELEASE-1.noarch.rpm \
  && yum -y localinstall spring-xd-1.3.1.RELEASE-1.noarch.rpm \
  && rm -fv spring-xd-1.3.1.RELEASE-1.noarch.rpm \
  && alternatives --install /usr/bin/xd-admin xd-admin /opt/pivotal/spring-xd/xd/bin/xd-admin 99999 \
  && alternatives --install /usr/bin/xd-container xd-container /opt/pivotal/spring-xd/xd/bin/xd-container 99999 \
  && alternatives --install /usr/bin/xd-singlenode xd-singlenode /opt/pivotal/spring-xd/xd/bin/xd-singlenode 99999

else
  echo -e "\e[7;44;96m*sspring-xd-1.3.1.RELEASE-1 already appears to be installed. skipping."
fi
