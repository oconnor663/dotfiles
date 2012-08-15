# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

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
fi

eval `dircolors ~/.dir_colors`

stty -ixon

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -lh'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

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
