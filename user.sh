#!/bin/bash

if [ $# <2 ];then
    echo "eg: user.sh user passwd"
    exit 1

user = $1
passwd = $2


# 创建用户
useradd $user
echo $passwd | passwd --stdin $user
# 用户添加sudo
echo "$user ALL=(ALL) ALL" >>/etc/sudoers


# 仅允许某一用户ssh登录
echo "AllowUsers $user" >>/etc/ssh/sshd_config
systemctl restart sshd