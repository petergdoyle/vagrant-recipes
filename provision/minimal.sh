#!/bin/sh

yum -y update && yum -y clean
yum -y install vim htop curl wget tree unzip bash-completion
