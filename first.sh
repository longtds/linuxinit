# 系统升级和常用软件安装
yum makecache
yum update -y
yum install vim lsof net-tools sysstat tree htop iotop iftop wget unzip nc dos2unix nfs-utils -y

# 关闭firewalld和selinux
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
sed -i 's/=enforcing/=disabled/g' /etc/selinux/config

# 配置默认nofile为65535
echo '* - nofile 65535' >> /etc/security/limits.conf

# 配置vim
cat <<EOF >>/etc/vimrc
set tabstop=4
set shiftwidth=4
set expandtab
set nocompatible
set showcmd
set nu
EOF

# 脚本提示
demo(){
    if [ $# <3 ];then
        echo "eg: init.sh hostname user passwd"
        exit 1
}

demo
hostname = $1
user = $2
passwd = $3

Common(){
    # 主机名配置
    hostnamectl set-hostname $hostname
    # 时区配置
    yes | cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    # 创建用户
    useradd $user
    echo $passwd | passwd --stdin $user
    # 用户添加sudo
    echo "$user ALL=(ALL) ALL" >>/etc/sudoers
    # 删除不必要账户
    userdel adm
    userdel lp
    userdel sync
    userdel shutdown
    userdel halt
    userdel operator
    userdel games
    userdel ftp
    #删除不必要的群组
    groupdel adm
    groupdel lp
    groupdel games
    # 关闭不需要启动服务
    # 桌面网卡管理服务
    systemctl disable NetworkManager
    # 邮件服务
    systemctl disable postfix

}

# SSH配置
Sshd(){
    # 禁止root用户ssh登录
    echo "PermitRootLogin no" >>/etc/ssh/sshd_config
    # 修改ssh默认端口
    echo "Port 22333" >>/etc/ssh/sshd_config
    # 不显示登录欢迎信息
    echo "PrintMotd no" >>/etc/ssh/sshd_config
    # 仅允许某一用户ssh登录
    echo "AllowUsers $user" >>/etc/ssh/sshd_config
    # 配置远程超时
    echo "ClientAliveInterval 600" >>/etc/ssh/sshd_config
    echo "ClientAliveCountMax 3" >>/etc/ssh/sshd_config
    # 最大尝试登录次数
    echo "MaxAuthTries 6" >>/etc/ssh/sshd_config
    # 最大联机数
    echo "MaxStartups 5" >>/etc/ssh/sshd_config
    # 禁止空密码
    echo "PermitEmptyPasswords no" >>/etc/ssh/sshd_config
    # 仅允许使用SSH2
    echo "Protocol 2" >>/etc/ssh/sshd_config
}

# Shell历史记录配置
Shell_history(){
cat <<EOF >>/etc/profile
USER_IP = `who -u am i 2>/dev/null |awk '{print $NF}'|sed -e 's/[()]//g'`
HISTDIR = /usr/share/.history
if [ -z $USER_IP ]
then
    USER_IP = `hostname`
fi

if [ ! -d $HISTDIR ]
then
    mkdir -p $HISTDIR
    chmod 777 $HISTDIR
fi

if [ ! -d $HISTDIR/${LOGNAME} ]
then
    mkdir -p $HISTDIR/${LOGNAME}
    chmod 300 $HISTDIR/${LOGNAME}
fi

export HISTSIZE = 4000
DT = `date +%Y%m%d_%H%M%S`
export HISTFILE = "$HISTDIR/${LOGNAME}/${USER_IP}/.history.%DT"
export HISTTIMEFORMAT = "[%Y.%m.%d %H:%M:%S]"
chmod 600 $HISTDIR/%{LOGNAME}/*.history* 2>/dev/null
EOF
}

# tcp_wrappers防火墙
TCP_wrappers(){
    # 允许的网络
    echo "sshd: 192.168.199.0/24" >>/etc/hosts.allow
    echo "ALL:ALL" >>/etc/hosts.allow
    # 除192.168.190.253之外的所有网络
    echo "ALL:ALL EXCEPT 192.168.190.253" >>/etc/hosts.allow
    
    # 拒绝的网络
    echo "ALL: 192.168.2.0/24" >>/etc/hosts.deny
}

# 锁定关键文件
Chattr(){
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
}

# 定期检查文件权限
File_filter(){
cat <<EOF >>/usr/local/bin/check_file.sh
#!/bin/bash
date +%Y%m%d_%H:%M:%S
echo "系统中含有"s"位的程序"
find / -type f -perm -4000 -o -perm -2000 -print |xargs ls -ld 
echo "查看具有suid和sgid的文件"
find / -user root -perm -2000 -print -exec md5sum {} \;
find / -user root -perm -4000 -print -exec md5sum {} \;
echo "查看没有属组的文件"
find / -nouser -o -nogroup
EOF
chmod +x /usr/local/bin/check_file.sh
echo "0 2 * * * root /usr/local/bin/check_file.sh >>/usr/share/check_file.log"
}

# 内核升级
U_Kernel(){
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
}
