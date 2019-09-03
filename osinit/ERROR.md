#### "Too many open files"或者Socket/File: Can’t open so many files等错误
1. 查看用户文件句柄设置数:ulimit -n
2. 查看系统最大文件数:/proc/sys/fs/file-max
