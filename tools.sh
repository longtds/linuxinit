#!/bin/bash
# 系统升级和常用软件安装
yum makecache
yum update -y
yum install vim lsof net-tools sysstat tree htop iotop iftop wget unzip nc dos2unix nfs-utils -y