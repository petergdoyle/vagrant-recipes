#!/bin/sh

  if [ ! -d /usr/spark/spark-1.6.1-bin-hadoop2.6/ ]; then
    mkdir -p /usr/spark
    curl -O -L http://www-eu.apache.org/dist/spark/spark-1.6.1/spark-1.6.1-bin-hadoop2.6.tgz \
      && tar -xvf spark-1.6.1-bin-hadoop2.6.tgz -C /usr/spark \
      && ln -s /usr/spark/spark-1.6.1-bin-hadoop2.6/ /usr/spark/default \
      && rm -f spark-1.6.1-bin-hadoop2.6.tgz

    export SPARK_HOME=/usr/spark/default
    cat >/etc/profile.d/spark.sh <<-EOF
export SPARK_HOME=$SPARK_HOME
EOF

  install_dir='$SPARK_HOME/bin'
  for each in $(find $install_dir -executable -type f) ; do
    name=$(basename $each)
    alternatives --install "/usr/bin/$name" "$name" "$each" 99999
  done

  #set log levels
  cp /usr/spark/default/conf/log4j.properties.template /usr/spark/default/conf/log4j.properties
  sed -i 's/INFO/ERROR/g' /usr/spark/default/conf/log4j.properties

  else
    echo -e "\e[7;44;96m*spark-1.6.1 already appears to be installed. skipping."
  fi
