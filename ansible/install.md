#### CentOS
    sudo yum install epel-release -y
    sudo yum install ansible -y

#### Ubuntu
    sudo apt install ansible -y

#### 免密登录设置
    # 生成ssh key
    ssh-keygen
    # 拷贝ssh key到远程主机，ssh的时候就不需要输入密码了
    ssh-copy-id remoteuser@remoteserver
    # ssh的时候不会提示是否保存key
    ssh-keyscan remote_servers >> ~/.ssh/known_hosts
    # 对于有公钥单已关闭密码认证的主机
    scp -i /opt/default.pem id_rsa.pub centos@10.10.100.43:~/.ssh/authorized_keys