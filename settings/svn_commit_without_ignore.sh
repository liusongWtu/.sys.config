#!/bin/bash
#提交除了ignore的changelist分组中的文件
#用法：svn_commit_without_ignore.sh "提交信息"

#获取ignore中的文件,用,分割
ignore_file_string=`svn st --cl ignore|awk 'NR>2 {print $NF}'|awk -v files="" '{ files=(files$0",")}END{print files}'`

#获取改变的文件的文件，这里暂且统计svn st后以 A,M,D开头的文件
all_changed_files=` svn st|awk '$0 ~ /^A|^M|^D/ {print $2}'`

#获取要提交的文件
commit_files=""
for file in $all_changed_files
do
	if [[ $ignore_file_string != *$file","* ]]; then
	  commit_files+=$file" "
	fi
done

#设置提交信息
message=""
if [ $# == 0 ]
then
   message="commit by svn_commit_without_ignore.sh"
else
   message=$1
fi

svn commit -m $message $commit_files


