#!/bin/sh

eval 'java -version' > /dev/null 2>&1
if [ $? -eq 127 ]; then
  mkdir -p /usr/java
  #install java jdk 8 from oracle
  curl -O -L --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
  "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.tar.gz" \
    && tar -xvf jdk-8u60-linux-x64.tar.gz -C /usr/java \
    && ln -s /usr/java/jdk1.8.0_60/ /usr/java/default \
    && rm -f jdk-8u60-linux-x64.tar.gz

  export JAVA_HOME=/usr/java/default
  cat >/etc/profile.d/java.sh <<-EOF
export JAVA_HOME=$JAVA_HOME
EOF

  install_dir="$JAVA_HOME/bin"
  for each in $(find $install_dir -executable -type f) ; do
    name=$(basename $each)
    alternatives --install "/usr/bin/$name" "$name" "$each" 99999
  done

else
  echo -e "\e[7;44;96m*java already appears to be installed. skipping."
fi
