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