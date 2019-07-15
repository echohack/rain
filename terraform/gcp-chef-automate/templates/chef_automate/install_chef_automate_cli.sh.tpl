#!/bin/bash

which unzip >/dev/null 2>&1
if [[ $? != 0 ]]; then
  cat /etc/os-release |grep -i centos >/dev/null
  if [[ $? != 0 ]]; then
    yum install -y unzip
  fi
  cat /etc/os-release |grep -i ubuntu >/dev/null
  if [[ $? != 0 ]]; then
    apt-get install -y unzip
  fi
fi

pushd "/tmp"
  curl https://packages.chef.io/files/current/automate/latest/chef-automate_linux_amd64.zip |gunzip - > chef-automate && chmod +x chef-automate
  mv chef-automate /usr/sbin/chef-automate
  mkdir -p /etc/chef-automate
popd
