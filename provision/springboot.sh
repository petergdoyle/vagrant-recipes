#!/bin/sh


curl -s get.sdkman.io | bash

su - vagrant -c 'source "/home/vagrant/.gvm/bin/gvm-init.sh"'
printf "gvm_auto_answer=true\ngvm_auto_selfupdate=true\n" > /home/vagrant/.gvm/etc/config
su - vagrant -c 'gvm install springboot groovy'
su - vagrant -c 'spring --version'
