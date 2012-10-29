alias kta='ps aux | grep "tmux attach" | grep -v "grep" | awk "{print \$2}" | xargs kill -9'
alias ta='kta; tmux attach'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias la='ls -A'
alias ll='la -lh'

export EDITOR=vim
export PATH=$PATH:~/bin

# add emacs keybindings on top of vi mode
bindkey -e
binds=`bindkey -L`
bindkey -v
for bind in ${(@f)binds}; do eval $bind; done
unset binds

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history

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