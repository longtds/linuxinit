#!/bin/bash

# 内核升级需要依照实际需求使用，目前需要的地方是为了更好支持容器或者其他情况

# 导入公钥
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
# 安装内核源
yum install https://www.elrepo.org/elrepo-release-7.0-4.el7.elrepo.noarch.rpm -y
yum makecache
# 移除旧内核相关包
yum remove kernel-devel kernel-tools-libs kernel-tools kernel-headers -y
# 安装最新稳定版内核
yum --enablerepo=elrepo-kernel install kernel-ml.x86_64 -y
# 安装新内核相关包
yum --disablerepo=\* --enablerepo=elrepo-kernel install -y  kernel-ml-devel kernel-ml-tools kernel-ml-tools-libs kernel-ml-tools-libs-devel kernel-ml-headers
# 更新默认引导新内核
grub2-editenv list
grub2-set-default 0
grub2-mkconfig -o /etc/grub2.cfg
# 重启生效
reboot