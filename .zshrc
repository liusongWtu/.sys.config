#加载~/.oh-my-zsh/plugins目录下的插件
plugins=(web-search bundler rake git osx zsh-autosuggestions)

ZSH=$HOME/.oh-my-zsh

ZSH_THEME="af-magic"

source $ZSH/oh-my-zsh.sh

source ~/.bash_profile

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**'
zstyle ':completion:*:*' ignored-patterns '*ORIG_HEAD'

compinit -u
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000000
# End of lines configured by zsh-newuser-install
#

rm -rf .zcompdump*

source ~/.sys.config/common.sh
source ~/.sys.config/dirmark/zsh.sh

export NVM_DIR="/Users/zxy/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
source ~/.nvm/nvm.sh

[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && . ~/.autojump/etc/profile.d/autojump.sh

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export CDPATH=/Users/zxy/dev/work

source $(brew --prefix)/etc/profile.d/autojump.sh
fpath=(/usr/local/share/zsh-completions $fpath)
alias logcat='adblogcat.py --ignore="eglCodecCommon" --ignore="OpenGLRenderer" --ignore="EGL_genymotion" --ignore="chromium" --ignore="libEGL" -i "dalvikvm" -i "top" -i "JDWP" -i "wpa_supplicant" -i "art"'

export M2_HOME=~/apache-maven-3.3.9
export PATH=$PATH:$M2_HOME/bin
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"


# pyenv
eval "$(pyenv init -)"


# mysql
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/mysql@5.7/lib"
export CPPFLAGS="-I/usr/local/opt/mysql@5.7/include"
export PKG_CONFIG_PATH="/usr/local/opt/mysql@5.7/lib/pkgconfig"

export PATH="/usr/local/opt/ncurses/bin:$PATH"

# golang
#GOPATH
export GOPATH=$HOME/program/go/libs:$HOME/Works:$HOME/work/xiaozi/jdcj/wxgame_go:$HOME/work/xiaozi/jdcj/game_micro
#GOPATH bin
######## export PATH=$PATH:/usr/local/opt/go/libexec/bin:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin:${GOPATH//://bin:}/bin
# GOPROXY
export GOPROXY=https://mirrors.aliyun.com/goproxy/
