#
# ~/.bashrc_include
#
# Add the following line into ~/.bashrc to load it
#
#   [[ -f ~/.bashrc_include ]] && source ~/.bashrc_include
#

# functions
setproxy() {
    #export http_proxy="http://10.1.0.1:6543"
    export http_proxy="http://127.0.0.1:8087"
    echo "http_proxy=$http_proxy"
}

# aliases
alias diff='diff -u'
alias dirs='dirs -v'
alias emacs='emacs -nw'
alias grep='grep --color=auto'
alias jobs='jobs -l'
alias la='ls -a'
alias ll='ls -l'
alias ls='ls --color=auto'
alias psc='ps xawf -eo pid,user,cgroup,args'
alias tig='tig --all'
alias vi='vim'

alias rusti='evcxr'

# PS1
parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'
}
find_git_branch () {
    local dir=. head
    until [ "$dir" -ef / ]; do
        if [ -f "$dir/.git/HEAD" ]; then
            head=$(< "$dir/.git/HEAD")
            if [[ $head = ref:\ refs/heads/* ]]; then
                git_branch="[${head#*/*/}]"
            elif [[ $head != '' ]]; then
                git_branch="[(detached)]"
            else
                git_branch="[(unknown)]"    # →
            fi
            return
        fi
        dir="../$dir"
    done
    git_branch=''
}
PROMPT_COMMAND="find_git_branch; $PROMPT_COMMAND"
# Here is bash color codes you can use
  black=$'\[\e[1;30m\]'
    red=$'\[\e[1;31m\]'
  green=$'\[\e[1;32m\]'
 yellow=$'\[\e[1;33m\]'
   blue=$'\[\e[1;34m\]'
magenta=$'\[\e[1;35m\]'
   cyan=$'\[\e[1;36m\]'
  white=$'\[\e[1;37m\]'
 normal=$'\[\e[m\]'

PS1="$normal[\u:\W]$green\$git_branch$white\$ $normal"

# bash history
export HISTTIMEFORMAT="%Y/%d/%m %T "

# pager
export PAGER=/usr/bin/less

export VISUAL=vim

# turn off the annoying beep. Comment out because xterm no longer supports it.
#setterm --blength 0
xset -b

# bash completion for git
GIT_COMPLETION_SCRIPT=/usr/share/git/completion/git-completion.bash
if [ -f $GIT_COMPLETION_SCRIPT ]; then
    source $GIT_COMPLETION_SCRIPT
fi

# load shared environment variables (e.g. with KDE, etc)
[[ -f ~/.bashrc_shared_env.sh ]] && source ~/.bashrc_shared_env.sh
