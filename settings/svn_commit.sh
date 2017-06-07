#!/bin/bash
#缺陷：changelist分组中的文件提交后，changelist分组就被清空了

# echo start commit.sh
# echo $*
#获取新添加的文件
add_files=`svn st|awk '/^A/ {print $2} '|awk -v files="" '{ files=(files" "$0)}END{print files}'`

#设置提交组
group=""
if [ $# == 0 ]
then
   group="work"
else
   group=$1
fi

#获取group组中要提交的文件
group_files=`svn st --cl $group|awk '/^M/ {print $2}'|awk  '{ files=(files" "$0)}END{print files}'`

length=${#group_files}
group_files=${group_files:1:$length}
# echo $group_files
#获取提交描述
message="commit by commit.sh"
if [ $# -gt 1 ]
then
   message=$2
fi
# echo $message

#提交文件，add_files和group_files有重复也可以正常提交
# echo "svn commit -m 'svn test' $group_files"
svn commit -m $message $add_files $group_files

