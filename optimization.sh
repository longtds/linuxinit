#!/bin/bash

cat <<EOF >> /etc/security/limits.conf
# 限制内核文件大小为0
* - core 0
# 增大最小文件句柄数
* - nofile 65535
# 增大最小进程数
* - nproc 25059
# 文件大小无限制
* - fsize unlimited
# 虚拟内存无限制
* - as unlimited
EOF

# 配置内核调优
cat <<EOF >>/etc/sysctl.conf
# 增大每个套接字缓冲区大小
net.core.optmem_max = 81920
# 增大套接字接收缓冲区大小
net.core.rmem_max = 513920
# 增大套接字发送缓冲区大小
net.core.wmem_max = 513920
# 增大TCP接收缓冲区范围
net.ipv4.tcp_rmem = 4096 87380 16777216
# 增大TCP发送缓冲区范围
net.ipv4.tcp_wmem = 4096 87380 16777216
# 增大UDP缓冲区范围
net.ipv4.udp_mem = 188562 251418 377124

# 增大处于TIME_WAIT状态连接数量
net.ipv4.tcp_max_tw_buckets = 1048576
# 增大连接跟踪表大小
net.netfilter.nf_conntrack_max = 1048576
net.netfilter.nf_conntrack_buckets = 65536
# 缩短处于TIME_WAIT状态的超时时间
net.ipv4.tcp_fin_timeout = 15
# 缩短连接跟踪表中处于TIME_WAIT状态的超时时间
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 30
# 允许TIME_WAIT状态占用端口还可以用到新建的连接中
net.ipv4.tcp_tw_reuse = 1
# 增大本地端口号范围
net.ipv4.ip_local_port_range = 10000 65535
# 开启SYN Cookie,防止SYN攻击
net.ipv4.tcp_syncookies = 1
# 缩短发送keepalive探测包发送间隔时间
net.ipv4.tcp_keepalive_intvl = 30
# 减少keepalive探测失败后重试次数
net.ipv4.tcp_keepalive_probes = 3
# 缩短最后一次数据包到keepalive探测包间隔时间
net.ipv4.tcp_keepalive_time = 600

# 开启网络转发
net.ipv4.ip_forward = 1
# 默认TTL为64,增大会降低性能
net.ipv4.ip_default_ttl = 64
# 数据包反向地址校验,防止IP欺骗，减少DDos攻击,这里需要修改对应的网卡名称
net.ipv4.conf.eth0.rp_filter = 1
# 禁用ICMP协议
net.ipv4.icmp_echo_ignore_all = 1
# 禁用广播ICMP
net.ipv4.icmp_echo_ignore_broa = 1

# 增大系统中每一个端口最大的监听队列的长度
net.core.somaxconn = 2048
# 限制一个进程可以拥有的VMA(虚拟内存区域)的数量
vm.max_map_count = 262145

# iptables对bridge的数据进行处理
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-arptables = 1

# 增大ARP缓存表
net.ipv4.neigh.default.gc_thresh1 = 4096
net.ipv4.neigh.default.gc_thresh2 = 6144
net.ipv4.neigh.default.gc_thresh3 = 8192

# 脏页内存最多占用阈值2GB,文件系统写缓冲区大小,写缓冲使用到系统内存多少的时候，
# 开始向磁盘写出数据。增大之会使用更多系统内存用于磁盘写缓冲，也可以极大提高系统的写性能
vm.dirty_bytes = 2147483648
# 脏页内存占用阈值1GB,写缓冲使用到系统内存多少的时候，pdflush开始向磁盘写出数据
vm.dirty_background_bytes = 1073741824
# 脏页内存数据刷新进程pdflush的运行间隔2s,默认5s
vm.dirty_writeback_centisecs = 200
# 脏数据能存活的时间10s,默认30s,Linux内核写缓冲区里面的数据多“旧”了之后，
# pdflush进程就开始考虑写到磁盘中去
vm.dirty_expire_centisecs = 1000
EOF
sysctl -p