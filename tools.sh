#!/bin/bash

# 以mini方式安装操作系统，安装完成后需要做升级升级处理，防止部分软件漏洞
yum makecache
yum update -y

# 安装常用的工具和应用依赖的工具，可根据实际情况添加
yum install vim lsof net-tools sysstat tree htop iotop iftop wget unzip nc dos2unix nfs-utils -y