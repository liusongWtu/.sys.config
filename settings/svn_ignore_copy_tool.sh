#!/bin/bash 

#使用：将dir1目录下所有ignore信息应用到dir2目录上
#eg: ./svn_ignore_copy_tool.sh dir1 dir2

if [ $# -ne 2 ]
then
    echo "参数不合法，示例：./svn_ignore_copy_tool.sh copiedDir destinationDir"
    echo "copiedDir:被拷贝Ignore信息的目录；destinationDir：要设置忽略文件的目录"
    exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
IGNORE_TXT=`svn propget -R svn:ignore $1` 

echo "\"$1\"的忽略文件列表为："
echo "$IGNORE_TXT"

echo "---------------------------------------------------------------------------------------------"
echo "\"$2\"应用后忽略列表为："
# IGNORE_TXT=$(echo "$IGNORE_TXT"|sed -E "s/^$1[[:space:]]+/$2 /g;s/^$1\//$2\//g")
COPIED_DIR="$( cd $1&& pwd )"
DESTINATION_DIR="$( cd $2&& pwd )"
IGNORE_TXT=$(echo "$IGNORE_TXT"|sed -E "s#^$COPIED_DIR#$DESTINATION_DIR#g")

echo "$IGNORE_TXT"

echo "---------------------------------------------------------------------------------------------"

# 移除要忽略的文件
echo '移除要忽略的文件：'
echo "$IGNORE_TXT"|awk 'BEGIN{files="";parent=""} {if($1==""){} else if($2=="-"){ parent=$1;print parent"/"$3;} else { print parent"/"$1;}}'|sed 's#\\#\/#g'|while read -r file;
do
    # echo $file
    svn remove --keep-local --force "$file"
done

# 设置忽略文件
echo "---------------------------------------------------------------------------------------------"
echo '设置忽略文件：'
# 获取忽略文件参数，从第二个参数开始，第一个参数为忽略文件父目录
embed_newline()
{
   local p="$2"
   shift
   shift #每次运行shift(不带参数的),销毁一个参数，后面的参数前移
   for i in "$@"
   do
      p="$p\n$i"         # Append
   done
   echo -e "$p"          # Use -e
}

get_first(){
    echo $1
}

echo "$IGNORE_TXT"|awk 'BEGIN{ sum=1;files="";parent="";}{if($1==""){result[sum]=parent" "files;sum+=1;files="";}else if($2=="-"){files=$3;parent=$1;}else{files=(files" "$1);}}
END{result[sum]=parent" "files; for(i=1; i<=sum; i++) { print result[i] }}'|sed 's#\\#\/#g'|while read -r file;
do
    dir=$(get_first $file)
    params=$(embed_newline $file)
    # echo $dir
    svn propset svn:ignore "$params" "$dir"
    echo "$params"
done













#  echo "$IGNORE_TXT"|awk '{ if($2=="-"){ cd $1;pwd; print $1;} else {print $1;}}' 

 # echo "$IGNORE_TXT"|awk -v PARENT=$TDIR '{ if($2=="-"){ COMMAND="cd "PARENT ;system(COMMAND); system("touch 11.txt");} else {print "111";}}' 
#  echo "$IGNORE_TXT"|awk -v PARENT=$DIR '{print PARENT"/"$1}'

# remove_files=`echo "$IGNORE_TXT"|awk 'BEGIN{files="";parent=""} {if($2=="-"){ parent=$1;files=(files" "parent"/"$3);} else { files=(files" "parent"/"$1);}}END{print files}'`
# remove_files=`echo "$IGNORE_TXT"|awk  'BEGIN{files="";parent=""} {if($2=="-"){ parent=$1;files=parent"/"$3;print files;} else { }}END{print files}'`
# echo $remove_files
# svn remove --keep-local --force $remove_files 




# ignores=`echo "$IGNORE_TXT"|awk '{print $1;}'`
# dir="test"
# svn propset svn:ignore "$ignores" $dir

# remove_files=`echo "$IGNORE_TXT"|awk 'BEGIN{files="";parent="";} {if($1==""){print "空行";print parent;print files;files="";} else if($2=="-"){ files=(files"\n"$3);parent=$1;} else { print "内容行";print $0;print parent;files=(files"\n"$1);}}END{print files;}'`
# echo "$remove_files"


# remove_files=`echo "$IGNORE_TXT"|awk 'BEGIN{files="";parent="";}{if($1==""){print "空行";print $0;print parent;print files;files="";}else if($2=="-"){print "头行";print $0;files=(files"\n"$3);parent=$1;}else{print "内容";print $0;files=(files"\n"$1);}}END{print files;}'`
# remove_files=`echo "$IGNORE_TXT"|awk 'BEGIN{files="";parent="";}{if($1==""){print "空行";print parent;print files; files="";}else if($2=="-"){files=$3;parent=$1;}else{files=(files"\n"$1);}}END{print parent;print files;}'`
# remove_files=`echo "$IGNORE_TXT"|awk -v result=re 'BEGIN{ sum=1;files="";parent="";}{if($1==""){result[sum]="@"parent;sum+=1;result[sum]=files;sum+=1;
#  files="";}else if($2=="-"){files=$3;parent=$1;}else{files=(files"\n"$1);}}END{result[sum]="@"parent;sum+=1;result[sum]=files;sum+=1;for(i=1; i<=sum; i++) { print result[i]; }}'`




# remove_files=`echo "$IGNORE_TXT"|awk 'BEGIN{ sum=1;files="";parent="";}{if($1==""){result[sum]=parent" "files;sum+=1;files="";}else if($2=="-"){files=$3;parent=$1;}else{files=(files" "$1);}}
# END{result[sum]=parent" "files; for(i=1; i<=sum; i++) { print result[i] }}'`

# echo "$remove_files"

# for ignore_str in "$remove_files"
# do
#     echo $ignore_str
# done




# file1=2.properties
# file1=$("$file1"'\n'"me")
# echo $file1
# # file12=me
# # echo $file1$'\n'$file2
# echo "-----"
# echo "2.properties"$'\n'"me"

# svn propset svn:ignore "$file1"$'\n'"$file2" test

#??
# VAR=2.properties
# VAR="$VAR"$'\n'me
# echo "$VAR"

# save $VAR



# var="2.properties me"
# p=$( embed_newline $var )  # Do not use double quotes "$var"
# echo "$p"
# svn propset svn:ignore "$p" test
