# ignore and delete duplicate
export HISTCONTROL=ignoreboth
# ignore the following commands
export HISTIGNORE="[ ]*:&:bg:fg:exit:history"
# the filesize
export HISTFILESIZE=1000000000
# the history items count
export HISTSIZE=1000000
# append history

if which shopt >/dev/null; then
    shopt -s histappend
fi
# after the command finish,append it
PROMPT_COMMAND="history -n;history -a;$PROMPT_COMMAND"

# good experience with ls.
alias la='ls -al'

# good experience with cd.
alias .='cd -'
alias ..='cd ..'
alias ...='cd ../..'

# o is alias to open in mingw/cygstart in cygwin/nautilus in ubuntu
alias op='o ..'
alias oo='o .'

# alias to open favorite sites.
# ou is alias to open url.
alias ogoogle='ou https://www.google.com.tw'
alias oengoogle='ou https://www.google.com/ncr'
alias oweibo='ou http://weibo.com'

# better less
alias L='less -R'

# thanks to oreilly,this is a really good alias.
# http://www.oreillynet.com/onlamp/blog/2007/01/whats_in_your_bash_history.html
# Compress the cd, ls -l series of commands.
alias lc='cl'
function cl ()
{
    if [ $# = 0 ]; then
        cd && ll
    else
        cd "$*" && ll
    fi
}

function mkcd ()
{
    mkdir -p "$@" && eval cd "\"\$$#\"";
}

function sct()
{
    i=$1
    if [[ $i -gt $(date +"%s")*100 ]]; then i=$i/1000; fi
    sqlite3 "" "select datetime($i, 'unixepoch', 'localtime');" 2>>/dev/null | awk '/[0-9]+-/{print $0}'
}

alias glpdir='fzf --bind "enter:execute(git log -p {})"'
alias gvimdir='fzf --bind "enter:execute(gvim --servername idea_common --remote-tab-silent {})"'

function gvimServer() {
    local server=$(gvim --serverlist|grep -v VIM|head -1)
    [[ -z "$server" ]] && server='SERVER'
    gvim --servername "$server" --remote-tab-silent "$*"
}
