#!/bin/bash

# 添加VIM配置仅仅为了方便使用

cat <<EOF >>/etc/vimrc
`echo`
set tabstop=4
set shiftwidth=4
set expandtab
set nocompatible
set showcmd
set nu
EOF