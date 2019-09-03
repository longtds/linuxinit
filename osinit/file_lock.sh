#!/bin/bash

# 锁定关键目录为防止rootkit

# 锁定系统关键目录不可修改
chattr -R +i /bin /sbin /lib /boot
# 锁定用户关键目录为只能添加
chattr -R +a /usr/bin /usr/include /usr/lib /usr/sbin
# 系统关键配置文件锁定不可修改
chattr +i /etc/passwd
chattr +i /etc/shadow
chattr +i /etc/hosts
chattr +i /etc/resolv.conf
chattr +i /etc/fstab
chattr +i /etc/sudoers
chattr -R +i /etc/sudoers.d
# 系统日志系统锁定为只能添加
chattr +a /var/log/messages
chattr +a /var/log/wtmp