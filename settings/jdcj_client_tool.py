#! python3
# -*-coding:utf-8 -*-
# python3 jdcj_client_too.py 服务器 目录名 用户名 选择用户序号（默认第一个）
# python3 jdcj_client_too.py test 1 白珞琰 1
# python3 jdcj_client_too.py pro 1 白珞琰 1

import requests
import sys
import os
import shutil
import re

sourceDir = "/Users/song/work/xiaozi/jdcj/battle/project/bin"
rootDir = "/Users/song/work/xiaozi/jdcj/"
env = sys.argv[1]
dstDir = rootDir + sys.argv[2]
tokenFile = dstDir + "/js/splash/SplashPage.js"
teamIDFile = dstDir + "/js/home/HomeUI.js"
if os.path.exists(dstDir):
    shutil.rmtree(dstDir)
# 复制目录，目标目录必须不存在
shutil.copytree(sourceDir, dstDir)

userName = "白珞琰"
if len(sys.argv) > 3:
    userName = sys.argv[3]
url = "https://wxgame.yz210.com/micro2/test/getuserdetail?name=" + userName
if env == "test":
    url = "http://192.168.1.210:19001/micro/test/getuserdetail?name=" + userName

r = requests.get(url)
# print(r.status_code)
print(r.content)
data = r.json()

userIndex = 0


# 修改token
if len(sys.argv) > 4:
    userIndex = int(sys.argv[4]) - 1
token = data["data"]["Users"][userIndex]["Token"]

pat = re.compile(
    r'(Account.instance.onToken\(QDef\.DEBUG\s+\?\s+")\w+("\s+:\s+")\w+("\);)')
# s = 'Account.instance.onToken(QDef.DEBUG ? "f7645341bbe3dc32b5d3ba4de2c35fde" : "c65cfc5027de026f2d37dc3d22e51343");'
# r = pat.sub(r'\g<1>' + token + '\g<2>' + token + '\g<3>', s)

fp_o = open(tokenFile, 'r')
text = fp_o.read()
fp_o.close()

r = pat.sub(r'\g<1>' + token + '\g<2>' + token + '\g<3>', text)
fp_i = open(tokenFile, 'w')
fp_i.write(r)
fp_i.close()

# 修改teamID
if len(sys.argv) > 5:
    teamID = sys.argv[5]
    # this.test.startGame(EnumBattleMode.SingleMelee, true, 's1_t_cf265996', false, '');
    pat = re.compile(
        r'(this\.test\.startGame\(EnumBattleMode\.SingleMelee\s*,\s*true\s*,\s*\')(.+)(\'\s*,\s*false\s*,\s*\'\'\);)')
    
    
    fp_o = open(teamIDFile, 'r')
    text = fp_o.read()
    fp_o.close()

    r = pat.sub(r'\g<1>'+teamID+r'\g<3>', text)
    fp_i = open(teamIDFile, 'w')
    fp_i.write(r)
    fp_i.close()

