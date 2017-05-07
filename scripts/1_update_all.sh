#!/bin/sh

yum -y update
yum -clean all

shutdown -r now
