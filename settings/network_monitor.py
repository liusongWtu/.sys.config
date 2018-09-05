# -*- coding:UTF-8 -*-
import re, time, datetime
import subprocess as sp


if __name__ == '__main__':
    cmd = "ping -c 3 8.8.8.8"
    network_available_cmd = 'terminal-notifier -message "有网络了" -title "网络提示" -timeout 2'

    while True:
        #执行命令
        p = sp.Popen(cmd, stdin=sp.PIPE, stdout=sp.PIPE, stderr=sp.PIPE, shell=True)
        #获得返回结果并解码
        out = p.stdout.read().decode("utf-8")
        # print(out)

        received_regex = re.compile(r'(\d+) packets transmitted, (\d+) packets received') 
        received_match = received_regex.search(out)
        received = int(received_match.group(2))
        # print(received)

        if received > 0:
            print("有网了")
            sp.call(network_available_cmd, shell=True)
            break
        else:
            current_time = datetime.datetime.now().strftime('%H:%M:%S')
            print("无网络:" + current_time)
            time.sleep(30)

