#!/bin/bash

if [ $# <3 ];then
    echo "eg: common.sh hostname"
    exit 1

hostname = $1

# 主机名配置
hostnamectl set-hostname $hostname
# 时区配置
yes | cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# 删除不必要账户
userdel adm
userdel lp
userdel sync
userdel shutdown
userdel halt
userdel operator
userdel games
userdel ftp
# 删除不必要的群组
groupdel adm
groupdel lp
groupdel games
# 关闭不需要启动服务
# 1.关闭桌面网卡管理服务
systemctl disable NetworkManager
# 2.关闭邮件服务
systemctl disable postfix