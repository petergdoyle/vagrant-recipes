#!/bin/sh

  eval 'scala -version' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
    mkdir -p /usr/scala
    curl -O -L "http://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.tgz" \
      && tar -xvf scala-2.11.8.tgz -C /usr/scala \
      && ln -s /usr/scala/scala-2.11.8/ /usr/scala/default \
      && rm -f scala-2.11.8.tgz

    export SCALA_HOME=/usr/scala/default
    cat >/etc/profile.d/scala.sh <<-EOF
export SCALA_HOME=$SCALA_HOME
EOF

  install_dir='$SCALA_HOME/bin'
  for each in $(find $install_dir -executable -type f) ; do
    name=$(basename $each)
    alternatives --install "/usr/bin/$name" "$name" "$each" 99999
  done

  else
    echo -e "\e[7;44;96m*scala-2.11.8 already appears to be installed. skipping."
  fi


  eval 'sbt help' > /dev/null 2>&1
    if [ $? -eq 127 ]; then
      mkdir -p /usr/sbt
      curl -O -L https://dl.bintray.com/sbt/native-packages/sbt/0.13.11/sbt-0.13.11.tgz \
      && tar -xvf sbt-0.13.11.tgz -C /usr/sbt \
      && mv /usr/sbt/sbt /usr/sbt/sbt-0.13.11 \
      && ln -s /usr/sbt/sbt-0.13.11 /usr/sbt/default \
      && rm -f sbt-0.13.11.tgz

      alternatives --install "/usr/bin/sbt" "sbt" "/usr/sbt/default/bin/sbt" 99999

      #this command will install sbt but it takes a while
      sbt

  else
    echo -e "\e[7;44;96m*sbt-0.13.11 already appears to be installed. skipping."
  fi
