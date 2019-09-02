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
# 删除不必要的用户组
groupdel adm
groupdel lp
groupdel games

# 不需要的服务设置为开机不启动
# 1.关闭桌面网卡管理服务
systemctl disable NetworkManager
# 2.关闭邮件服务
systemctl disable postfix