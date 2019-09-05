#### /etc/ansible/hosts配置
##### 最简单的hosts文件：
    # 支持ip或者域名
    192.168.1.50
    aserver.example.org
    bserver.example.org
##### 带分类的hosts文件:
    # 为一类型主机分组
    [webservers]
    foo.example.com
    bar.example.com
    [dbservers]
    one.example.com
    two.example.com
    three.example.com
##### 连续ip的hosts文件:
    # 添加连续ip主机
    [test]
    192.168.199.[5:20]

##### 指定用户密码端口的hosts文件:
    [test1]
    name1 ansible_ssh_host=192.168.1.111 ansible_ssh_user="root" ansible_ssh_pass="1234" ansible_ssh_port=2222
    name2 ansible_ssh_host=192.168.1.222 ansible_ssh_user="root" ansible_ssh_pass="1234" ansible_ssh_port=2222

##### 带参数群组hosts文件：
    [test2]
    name1 ansible_ssh_host=192.168.1.[20:50]
    [test2:vars]
    ansible_ssh_user=root
    ansible_ssh_pass="1234"
    testvar="test"

##### 多组合并hosts文件：
    [test3:children]
    test
    test1

#### hosts调用方法

##### 调用两个主机组的写法，以下webservers和dbservers都会被调用：
    ansible webservers:dbservers -m ping

##### 在webservers组中但不在dbsersers中的调用：
    ansible webservers:!dbservers -m ping

##### 在webservers组中并且在dbservers组中的才会调用：
    ansible webservers:&dbservers -m ping

##### 在调用前加~，代表正则表达式：
    # web.*.gistack.com 或者db.*.gistack.com,其中*表示任意多字符匹配
    ansible ~(web|db).*.gistack.com -m ping

##### 多个组合的例子：
    ansible webserver:dbservers:&nginx:!ntp -m ping