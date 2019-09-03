#!/bin/bash

# 配置主机名、时区、时间同步、删除不需要的用户和组、关闭不需要开机启动的服务

if [ $# <2 ];then
    echo "eg: common.sh hostname ntpserver"
    exit 1

hostname = $1
ntpserver = $2

# 主机名配置
hostnamectl set-hostname $hostname

# 时区配置
yes | cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 时间同步
# 如果有公网可以配置使用ntp.aliyun.com，也可内建ntp服务器
sed -i '/iburst/d' /etc/chrony.conf
sed -i "1iserver $ntpserver iburst" /etc/chrony.conf
systemctl restart chronyd
systemctl enable chronyd

# 删除不必要账户
userdel adm
userdel lp
userdel sync
userdel shutdown
userdel halt
userdel operator
userdel games
userdel ftp
# 删除不必要的用户组
groupdel adm
groupdel lp
groupdel games

# 不需要的服务设置为开机不启动
# 1.关闭桌面网卡管理服务
systemctl disable NetworkManager
# 2.关闭邮件服务
systemctl disable postfix