#!/bin/bash

# 定期检查文件权限
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

# 每天2:00进行文件检查
echo "0 2 * * * root /usr/local/bin/check_file.sh >>/usr/share/check_file.log"