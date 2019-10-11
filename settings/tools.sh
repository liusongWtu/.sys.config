#!/bin/bash

#检测网络是否可用
function networkMonitor(){
    python $_CONFIG_BASE/settings/network_monitor.py
}

#绝地吃鸡客户端快速创建
function jdcjClient(){
    if [ $# -lt 2 ] ; then
        echo "jdcjClient 服务器  目录名 用户名 选择用户序号(默认第一个,从1开始）"
        echo "测试服示例:  jdcjClient test 1 白珞琰 1"
        echo "线上示例:  jdcjClient test 1 白珞琰 1"
        return
    fi
    python3 $_CONFIG_BASE/settings/jdcj_client_tool.py $*
}