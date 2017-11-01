#!/bin/bash

#检测网络是否可用
function networkMonitor(){
	python $_CONFIG_BASE/settings/network_monitor.py
}

