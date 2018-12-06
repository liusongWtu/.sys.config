#!/bin/bash 

if [ $* == "help" ]
then
    echo "示例：svnIgnoreAdd /a/b 表示把a目录下的b(若为目录则包含子目录下所有文件)加入忽略文件"
    exit 1
fi

svn add $1
svn remove --keep-local --force $1

NEWLINE=$'\n'
if [[ -d $1 ]]; then
    cd $1
    IGNORE_DIR=$(pwd)
    IGNORE_FILE=$(basename "$IGNORE_DIR")
    IGNORE_DIR=$(dirname $IGNORE_DIR)
    IGNORE_TXT=$(svn propget svn:ignore $IGNORE_DIR)
    REGEX="^"${IGNORE_FILE}"$"
    MATCH_RESULT=$(svn pg svn:ignore $IGNORE_DIR|grep -E $REGEX)
    if [[ -n "$MATCH_RESULT" ]]; then
        echo -e "\n\n error: ignore file has been added."
        exit 0
    fi
    IGNORE_TXT="$IGNORE_TXT$NEWLINE$IGNORE_FILE"
    svn propset svn:ignore "$IGNORE_TXT" "$IGNORE_DIR"
    echo "\"$IGNORE_DIR\"的忽略文件列表为："
    echo $IGNORE_TXT
elif [[ -f $1 ]]; then
    IGNORE_DIR=$(dirname $1)
    IGNORE_FILE=$(basename $1)
    IGNORE_TXT=$(svn propget svn:ignore $IGNORE_DIR)
    if [[ $IGNORE_TXT = *$IGNORE_FILE* ]]; then
        exit 0
    fi
    IGNORE_TXT="$IGNORE_TXT$NEWLINE$IGNORE_FILE"
    echo $IGNORE_TXT
    svn propset svn:ignore "$IGNORE_TXT" "$IGNORE_DIR"
    echo "\"$IGNORE_DIR\"的忽略文件列表为："
    echo $IGNORE_TXT
else
    echo "$1 is not valid"
    exit 1
fi