# good experience with svn.
export SVN_EDITOR=vim
alias sst='svn st'
alias sdi='svn diff'
alias sdv='svn diff|gvim -R -'
alias sre='svn revert'
alias scm='svn commit -m'
alias sup= 'svn update'

function svnRemoveDeletedFiles() {
    svn st|awk '/^!/ {print $2}'|sed 's#\\#\/#g'|while read -r file;
do
    svn remove --force "$file"
done
}

function svnAddUntrackedFiles() {
    svn st|awk '/^?/ {print $2}'|sed 's#\\#\/#g'|xargs svn add --force
}

function svnRemoveAddedFiles() {
    svn st|awk '/^A/ {print $2}'|tac|sed 's#\\#\/#g'|while read -r file;
do
    svn remove --keep-local --force "$file"
done
}

function svnRepoUrl() {
    svn info "$*"| grep URL|sed -e s/URL:\ //g
}
