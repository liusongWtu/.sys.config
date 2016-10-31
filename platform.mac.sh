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

function h() {
    function isNum(){
        if [ $1 -ge 0 ] && [ $1 -le 1000000 ]; then
            return 0 # 0 means true
        else
            return 1 #1 means false
        fi
    }
    if isNum $1; then
        list=$(history | tail -10)
        array=("${(@s/ /)list}")
        n=0
        for i in ${array[@]}; do
            echo "$n $i"
            ((n=n+1))
            echo "end"
        done
        echo "number"
    else
        echo "letter"
    fi
}

BASEDIR=$(dirname $0)
[[ -L "$BASEDIR"/bin/gvim ]] || (cd "$BASEDIR"/bin/;ln -s mac_vim_startup_script gvim)
