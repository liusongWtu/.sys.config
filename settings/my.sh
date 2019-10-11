alias cls='clear'
alias ll='ls -l'
alias la='ls -a'
alias vi='vim'
alias javac="javac -J-Dfile.encoding=utf8"
alias grep="grep --color=auto"
alias -s html=mate   # 在命令行直接输入后缀为 html 的文件名，会在 TextMate 中打开
alias -s rb=mate     # 在命令行直接输入 ruby 文件，会在 TextMate 中打开
alias -s py=vi       # 在命令行直接输入 python 文件，会用 vim 中打开，以下类似
alias -s js=vi
alias -s c=vi
alias -s java=vi
alias -s txt=vi
alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s zip='unzip'
alias -s bz2='tar -xjvf'

alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."


# dirs
alias cdwxgame_go='cd /Users/song/Server/go/wxgame_go'
alias cdcjclient='cd /Users/song//work/xiaozi/jdcj/battle'
alias cdcjdocuments='cd /Users/song/work/xiaozi/jdcj/jdcj/配置表'
alias cdcjfight='cd /Users/song/work/xiaozi/jdcj/wxgame_go'
alias cdcjmicro='cd /Users/song/work/xiaozi/jdcj/game_micro'

# tool
alias airportdpid=`ps aux | grep -v grep | grep /usr/libexec/airportd | awk '{print $2}'`
alias kill9='sudo kill -9'
#https://zhuanlan.zhihu.com/p/19556676
