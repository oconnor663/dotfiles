alias kta='ps aux | grep "tmux attach" | grep -v "grep" | awk "{print \$2}" | xargs kill -9'
alias ta='kta; tmux attach'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias la='ls -A'
alias ll='la -lh'

export EDITOR=vim
export PATH=$PATH:~/bin

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

# Load settings specific to this machine.
local_zshrc=~/.zshrc.local
if [ -e "$local_zshrc" ]
then
  source "$local_zshrc"
fi
