#!/usr/bin/env bash


#add the puppet repository
echo "Installing puppet agent."
yum install https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm -y
yum install puppet -y

