alias o='open'
alias ou='open'
alias ll='ls -alG'
alias ip="ifconfig | sed -n -e '/127.0.0.1/d' -e '/inet /p'|awk '{print \$2}'"

export DIFFMERGE_EXE=/Applications/DiffMerge.app/Contents/MacOS/DiffMerge

# Follow this page to avoid enter password
# http://apple.stackexchange.com/questions/236806/prevent-networksetup-from-asking-for-password
function proxy-charles()
{
    sudo networksetup -setwebproxystate Wi-Fi on;
    sudo networksetup -setsecurewebproxystate  Wi-Fi on;
    sudo networksetup -setwebproxy Wi-Fi 127.0.0.1 8888;
    sudo networksetup -setsecurewebproxy Wi-Fi 127.0.0.1 8888;
    sudo networksetup -setautoproxystate Wi-Fi off;
    sudo networksetup -setsocksfirewallproxystate Wi-Fi off;
}

function proxy-google()
{
    sudo networksetup -setwebproxystate Wi-Fi off;
    sudo networksetup -setsecurewebproxystate  Wi-Fi off;
    sudo networksetup -setautoproxystate Wi-Fi on;
    sudo networksetup -setautoproxyurl Wi-Fi http://pac.internal.baidu.com/bdnew.pac;
    sudo networksetup -setsocksfirewallproxystate Wi-Fi off;
}

function proxy()
{
	case "$1" in
	on)
		sudo networksetup -setsocksfirewallproxystate Wi-Fi on
		;;
	off)
		sudo networksetup -setsocksfirewallproxystate Wi-Fi off
		;;
	set)
		local domain="$2"
		local port="$3"
		if [ -z "$domain" ] || [ -z "$port" ]; then
			echo "Usage: proxy set domain port"
		else
			sudo networksetup -setsocksfirewallproxy Wi-Fi "$domain" "$port"
		fi
		;;
	status|st)
		networksetup -getsocksfirewallproxy Wi-Fi
		;;
	*)
		echo "Usage: proxy {on|off|set|status}"
		;;
	esac
}

function ow()
{
    if [[ -n "$@" ]]; then
        (cd "$@" && ow)
    else
        if ls *.xcodeproj 2>&1 1>/dev/null; then
            for i in *.xcodeproj;open "$i"
        else
            echo "ERROR, xcode project not exists in '$(pwd)' !"
            echo "Use this in xcode project directory or use 'ow <DIRECTORY>'"
        fi
    fi
}

function bsgrep()
{
#如果不指定文件名，默认是当前目录下递归搜索，否则在指定文件名中搜索
    if [ $# -eq 1 ]; then
        grep -rna "$1" .
    else
        grep -na "$1" "$pwd/$2"
    fi
}

function h(){
    history | grep --color=always -i $1 | awk '{$1="";print $0}' | # 查找关键字，去掉左侧的是数字 \
    sort | uniq -c | sort -rn | awk '{$1="";print NR " " $0}' | # 先去重（需要排序）然后根据次数排序，再去掉次数 \
    tee ~/.histfile_color_result | gsed -r "s/\x1B\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K]//g" |  # 把带有颜色的结果写入临时文件，然后去除颜色 \
    awk '{$1="";print "function " NR "() {" $0 "; echo \": $(date +%s):0;"$0"\" >> ~/.histfile }"}' | # 构造 function，把 $0 写入到 histfile 中 \
    {while read line; do eval $line &>/dev/null; done}  # 调用 eval，让 function 生效
    cat ~/.histfile_color_result | sed '1!G;h;$!d' # 倒序输出，更容易看到第一条
}

function s() {
    word=$1
    cd ~/dev/DailyLearning
    ls | xargs cat | gawk 'BEGIN{RS="### "} {if(tolower($0) ~ /'"$word"'/)print "###", $0}' | egrep --color=always -i "$word|$|^"
}

function pt() {
    launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.polipo.plist
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.polipo.plist
    export http_proxy=http://localhost:8123
    export https_proxy=http://localhost:8123
}

mkcdir () {
    mkdir -p -- "$1" &&
    cd -P -- "$1"
}

# Android
function aupdate() {
     cd /tmp/1
    if [ -e tieba-release.apk  ]; then
        rm tieba-release.apk
    fi
    wget "http://ci.tieba.baidu.com/view/TBPP_Android/job/FC_Native_Android_Build_ICODE/""$1""/artifact/gen_apks/tieba-release.apk"
    adb install -rg tieba-release.apk
}

BASEDIR=$(dirname $0)
[[ -L "$BASEDIR"/bin/gvim ]] || (cd "$BASEDIR"/bin/;ln -s mac_vim_startup_script gvim)
