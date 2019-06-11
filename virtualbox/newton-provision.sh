#!/bin/bash

# tem repo for install newton repos
cat <<REPO > /etc/yum.repos.d/Newton.repo
[Newton]
name=CentOS-OpenStack-Newton
baseurl=http://vault.centos.org/centos/7.4.1708/cloud/\$basearch/openstack-newton/
enabled=1
REPO

# import SIG-Cloud GPG Key
rpm --import https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud
# install openstack newton repo
yum install -y centos-release-openstack-newton
# remote temp repo
rm -f /etc/yum.repos.d/Newton.repo
# fix baseurl of newton repo
sed -i "s#mirror.centos.org/centos/7/cloud#vault.centos.org/centos/7.4.1708/cloud#g" /etc/yum.repos.d/CentOS-OpenStack-newton.repo

# update packages
# yum update -y
# install openstack packages
yum install -y openstack-packstack

# disable network manager
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl enable network
systemctl start network

# setup openstack
packstack --allinone
