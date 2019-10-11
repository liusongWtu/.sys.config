#!/bin/bash

#列出吃鸡OSS上json目录文件
function ossCjJson(){
    if [ $# -lt 1 ] ; then
        echo "ossCjJson 目录名"
        echo "示例1:  ossCjJson dev"
        echo "示例2:  ossCjJson v14 "
        return
    fi
    ~/Software/ossutilmac64 ls oss://xz-game/pubg/$1/json/|sort
}

#列出吃鸡OSS上json目录文件
function ossCjCatJson(){
    if [ $# -lt 2 ] ; then
        echo "ossCjCatJson 目录名 文件名"
        echo "示例1:  ossCjCatJson dev ad_reward"
        echo "示例2:  ossCjCatJson v15 ad_reward"
        return
    fi
    ~/Software/ossutilmac64 cat oss://xz-game/pubg/$1/json/$2.json
}