#!/bin/bash

# 生产环境中我们不能使用root用户远程登录，只能使用普通用户

if [ $# <2 ];then
    echo "eg: user.sh user passwd"
    exit 1

user = $1
passwd = $2

# 创建系统默认用户，赋予sudo权限，仅允许这个用户进行远程ssh登录
# 创建用户
useradd $user
echo $passwd | passwd --stdin $user
# 用户添加sudo
echo "$user ALL=(ALL) ALL" >>/etc/sudoers


# 仅允许某一用户ssh登录
echo "AllowUsers $user" >>/etc/ssh/sshd_config
systemctl restart sshd