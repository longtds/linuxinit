#!/bin/bash

# SSH配置
cat <<EOF >>/etc/ssh/sshd_config
# 禁止root用户ssh登录
PermitRootLogin no
# 修改ssh默认端口
Port 22333
# 不显示登录欢迎信息
PrintMotd no
# 配置远程超时
ClientAliveInterval 600
ClientAliveCountMax 3
# 最大尝试登录次数
MaxAuthTries 6
# 最大联机数
MaxStartups 5
# 禁止空密码
PermitEmptyPasswords no
# 仅允许使用SSH2
Protocol 2
EOF

systemctl restart sshd
# 如果关闭密码登录，强制使用密钥登录可以添加如下选项：
# PasswordAuthentication no