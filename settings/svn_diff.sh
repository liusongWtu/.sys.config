#!/bin/bash
#列出对比文件变化，默认比最近10个
#eg:~/.sys.config/settings/svn_diff.sh file number
#  ~/.sys.config/settings/svn_diff.sh src/modules/ad/AdManager.ts 5

file_name=$1
if [ $# -ge 2 ]
then
    diff_count=$2
else
    diff_count=10
fi
file_versions_str=`svn log $file_name -l $diff_count|awk '/^r/ {print $1}'|sed 's/r\(.*\)/\1/g'|awk -v files="" '{ files=(files" "$0)}END{print files}'`

IFS=' ' read -ra ADDR <<< "$file_versions_str"
last_version=""
for i in "${ADDR[@]}"; do
    echo -e "\n\n\n"
    if [ -z "$last_version" ]
    then
        last_version=$i
    else
        svn diff -r $i:$last_version $file_name
        last_version=$i
    fi
done

# files_versions=`svn st|awk '/^M/ {print $2} '|awk -v files="" '{ files=(files" "$0)}END{print files}'`



