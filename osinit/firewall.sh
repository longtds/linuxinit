#!/bin/bash

# 在云环境中，云平台有可靠的安全措施，为了方便使用一般都是关闭firewalld和selinux，
# 但是有必要开启TCP_wrappers防火墙，仅允许内部网络
# 处于应用边缘节点还是需要开启firewalld和selinux服务

systemctl stop firewalld
systemctl disable firewalld
setenforce 0
sed -i 's/=enforcing/=disabled/g' /etc/selinux/config

TCP_wrappers(){
    # 允许的网络
    echo "sshd: $1" >>/etc/hosts.allow
    # echo "ALL:ALL" >>/etc/hosts.allow
    # 除192.168.190.253之外的所有网络
    # echo "ALL:ALL EXCEPT 192.168.190.253" >>/etc/hosts.allow
    
    # 拒绝的网络
    echo "ALL: $2" >>/etc/hosts.deny
}

if [ $# =2 ];then
    TCP_wrappers $1 $2
fi