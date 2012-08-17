# If not running interactively, don't do anything
[ -z "$PS1" ] && return

alias kta='ps aux | grep "tmux attach" | grep -v "grep" | awk "{print \$2}" | xargs kill -9'
alias ta='kta; tmux attach'
alias hl='hphpd -h localhost'
alias gca='git commit -a --amend -C HEAD'
alias frb='git fetch; git rebase trunk; arc build'

export EDITOR=vim

if [[ `type -t __git_ps1` = function ]]
then
  export PS1="\[\e[0;36m\]\u@\h\[\e[m\] \[\e[0;34m\]\w\[\e[m\] \[\e[0;33m\]\$(__git_ps1 %s)\[\e[m\]\$ "
else
  export PS1="\[\e[0;36m\]\u@\h\[\e[m\] \[\e[0;34m\]\w\[\e[m\] $ "
fi

if [ $TERM = xterm ]
then
  export TERM=xterm-256color
elif [ $TERM = screen ]
then
  export TERM=screen-256color
elif [ $TERM = linux ]
then
  ~/.dotfiles/solarized-linux-console.sh
fi

eval `dircolors ~/.dotfiles/dir_colors`

stty -ixon

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -A'
alias l='ls -CF'

function fixauth() {
  if [[ -n $TMUX ]]; then
    #TMUX gotta love it
    eval $(tmux showenv | grep -vE "^-" | awk -F = '{print "export "$1"=\""$2"\""}')
  fi
}

# hook for preexec
preexec () { fixauth; }
preexec_invoke_exec () {
      [ -n "$COMP_LINE" ] && return  # do nothing if completing
          local this_command=`history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//g"`;
              preexec "$this_command"
}
trap 'preexec_invoke_exec' DEBUG

# Load settings specific to this machine.
local_bashrc=~/.bashrc.local
if [ -e "$local_bashrc" ]
then
  source "$local_bashrc"
fi
