#!/bin/bash
# good experience with svn.
export SVN_EDITOR=vim
# alias sst='svn st|grep -v  -e "^\s"'
alias sst='svn st'
alias sdi='svn diff'
alias sdv='svn diff|gvim -R -'
alias sre='svn revert'
alias scm='svn commit -m'
#添加文件到ignore的changelist分组中
alias svnclia='svn cl ignore '
alias svnclwa='svn cl work '
#将文件从changelist组中移除
alias svnclr='svn cl --remove '
#将work分组中的文件清空
alias svnclwr='svn cl --remove --recursive  --cl  work .'
#将ignore分组清空
alias svnclir='svn cl --remove --recursive  --cl  ignore .'
#提交work中changelist分组
alias svnclwc='svn ci --cl work -m '
alias svnclic='svn ci --cl ignore -m '
#显示changelist分组信息
alias svnclstw='svn st --cl work'
alias svnclsti='svn st --cl ignore'

alias svnup= 'svn update'

#提交除了ignore的changelist分组中的文件
#用法：svnCommit "提交信息"
function svnCommit(){
	$_CONFIG_BASE/settings/svn_commit_without_ignore.sh $*
}

#提交work组及新添加文件
#使用方法: svnCommitFiles work "提交信息"
function svnCommitFiles() {
	# # trap 'echo "before execute line:$LINENO, group=$group"' DEBUG
	# #获取新添加的文件
	# add_files=`svn st|awk '/^A/ {print $2} '|awk -v files="" '{ files=(files" "$0)}END{print files}'`

	# #设置提交组
	# group=""
	# if [ $# == 0 ]
	# then
	#    group="work"
	# else
	#    group=$1
	# fi

	# #获取group组中要提交的文件
	# group_files=`svn st --cl $group|awk '/^M/ {print $2}'|awk  '{ files=(files" "$0)}END{print files}'`

	# length=${#group_files}
	# group_files=${group_files:1:$length}
	# echo $group_files
	# #获取提交描述
	# message=""
	# if [[ $# -gt 1 ]] then
	# 	message=$2
	# fi
	# #提交文件，add_files和group_files有重复也可以正常提交
	# echo "svn commit -m 'svn test' $group_files"
	# svn commit -m 'svn test' $group_files
	$_CONFIG_BASE/settings/svn_commit.sh $*
}

function svnIgnoreCopy(){
	$_CONFIG_BASE/settings/svn_ignore_copy_tool.sh $*
}

function svnIgnoreAdd(){
	$_CONFIG_BASE/settings/svn_ignore_add_tool.sh $*
}

function svnRemoveDeletedFiles() {
    svn st|awk '/^!/ {print $2}'|sed 's#\\#\/#g'|while read -r file;
do
    svn remove --force "$file"
done
}

function svnRevertAll(){
	svn st| awk '/^M/ {print $2}'|sed 's#\\#\/#g'|while read -r file;
do
	svn revert "$file"
done
}

function svnAddUntrackedFiles() {
    # svn st|awk '/^\?/ {print $2}'|sed 's#\\#\/#g'|xargs svn add --force
    svn st|awk '/^\?/ {print $2}'|sed 's#\\#\/#g'|while read -r file;
do
    svn add --force "$file"
    svn cl work "$file"
    if [ -d $file ]
    then
   		svn st $file|awk '/^A/ {print $2}'|sed 's#\\#\/#g'|xargs svn cl work
	fi
done

}

function svnRemoveAddedFiles() {
	#tac is replaced by awk '{ buffer[NR] = $0; } END { for(i=NR; i>0; i--) { print buffer[i] }}'
    svn st|awk '/^A/ {print $2}'|awk '{ buffer[NR] = $0; } END { for(i=NR; i>0; i--) { print buffer[i] }}'|sed 's#\\#\/#g'|while read -r file;
do
	echo $file
    svn remove --keep-local --force "$file"
done
}

function svnRepoUrl() {
    svn info "$*"| grep URL|sed -e s/URL:\ //g
}

function svnShowConflicts() {
    svn st | grep -e '^C' -e '^?\s*C'
}

#添加到名为work的changelist
function svnAddAllUnChangelistFiles() {
# 法一：
# 	svn ls --recursive|sed 's#\\#\/#g'|while read -r file;
# do
# 	svn cl work "$file"
# done

# 法二
	svn ls --recursive|sed 's#\\#\/#g'|xargs svn cl work
}

function svnDiff(){
	$_CONFIG_BASE/settings/svn_diff.sh $*
}