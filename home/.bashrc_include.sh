####################################################################
#                                                                  #
# File: ~/.bashrc_include.sh                                       #
#                                                                  #
# Add the following line into ~/.bashrc to load it                 #
#                                                                  #
#   [[ -f ~/.bashrc_include.sh ]] && source ~/.bashrc_include.sh   #
#                                                                  #
####################################################################


####################################################################
#                                                                  #
# Basic Bash Configurations                                        #
#                                                                  #
####################################################################

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

# load environment variables
[[ -f ~/.env.sh ]] && source ~/.env.sh
[[ -f ~/.env.local.sh ]] && source ~/.env.local.sh


####################################################################
#                                                                  #
# Functions Definitions                                            #
#                                                                  #
####################################################################

#
# Enable/disable camera
#
camera() {
    local action="$1"
    
    case "$action" in
        on)
            echo "Loading module uvcvideo..."
            sudo modprobe uvcvideo
            ;;
        off)
            echo "Unloading module uvcvideo..."
            sudo modprobe -r uvcvideo
            ;;
        status)
            echo "Listing module uvcvideo..."
            local output=$(lsmod | grep ^uvcvideo)
            if [[ -z "$output" ]]; then
                echo "Module uvcvideo not found."
                echo "Camera disabled."
            else
                echo "Found module:"
                echo "$output"
                echo "Camera enabled."
            fi
            ;;
        *)
            echo "Enable/disable camera by loading/unloading module uvcvideo"
            echo "Usage: camera {on|off|status}"
            return 1
            ;;
    esac
}

# Auto-completion function
_camera_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local opts="on off status"
    
    COMPREPLY=($(compgen -W "$opts" -- "$cur"))
}

# Register camera completion function
complete -F _camera_completion camera
