if [[ $TERM = xterm || $TERM = xterm-256color ]] ; then
  export TERM=xterm-256color
  export SOLARIZED=1
fi

export EDITOR=vim
export PATH=~/bin:~/.local/bin:~/.cargo/bin:$PATH
DOTFILES=$HOME/dotfiles

# conveniences in the interactive Python interpreter
export PYTHONSTARTUP="$DOTFILES/startup.py"

alias ta='tmux attach'
alias grep='grep --color=auto'
alias i="ipython --no-confirm-exit"
alias i2="ipython2 --no-confirm-exit"
alias i3="ipython3 --no-confirm-exit"
alias open="xdg-open"
alias r='cd $(git rev-parse --show-toplevel || echo .)'
alias c='xclip -i -selection clipboard'
alias ct='tmux show-buffer | c'
alias v='xclip -o -selection clipboard'
alias find='noglob find' # easier wildcards
alias scp='noglob scp'   # ditto
alias sz='source ~/.zshrc'
alias pypi_upload='python setup.py register sdist upload'
alias tohex="python3 -c 'import sys, binascii; print(binascii.hexlify(sys.stdin.buffer.read()).decode())'"
alias fromhex="python3 -c 'import sys, binascii; sys.stdout.buffer.write(binascii.unhexlify(input().strip()))'"

# git aliases
alias git="noglob git" # zsh likes to swallow ^ characters
alias gs='git status'
alias gsi='git status --ignored'
alias gd='git diff'
alias gca="git commit -a --amend --no-edit"
alias gpr='git pull --rebase'
alias gfra='git fetch && git rebase --autostash'
alias gout='git log @{upstream}.. --oneline'
alias ginit='git init && git add -A && git commit -m "first commit"'
alias glog='git log --oneline --decorate --graph'
alias gref='git reflog --all --date=relative'

# State-saving commands for git. The `git clean` at the end of the last two is
# to handle a weird bug where inner git directories aren't removed (though the
# files they contain are removed).
alias save='git add -A  && git commit --allow-empty -qnm "SAVE" && git reset --mixed -q HEAD^'
alias wipe='git add -A  && git commit --allow-empty -qnm "WIPE" && git reset --hard  -q HEAD^ && git clean -dqff'
alias nuke='git add -Af && git commit --allow-empty -qnm "NUKE" && git reset --hard  -q HEAD^ && git clean -dqffx'

venv() {
  dir="$(mktemp -d)"
  target_python="${1:-python}"
  real_python="$(basename "$(realpath "$(which "$target_python")")")"
  virtualenv "$dir" -p "$real_python" --prompt "[$real_python] "
  source "$dir/bin/activate"
}

# ack is called ack-grep in ubuntu
if (( ! $+commands[ack] )) && (( $+commands[ack-grep]))
then
  alias ack=ack-grep
fi

# disable ctrl-s/crtl-q flow control
stty stop undef

# colors for ls
if [[ -n $SOLARIZED ]] ; then
  eval $(dircolors "$DOTFILES/dircolors-solarized/dircolors.ansi-dark")
fi
if ls --color=auto > /dev/null 2>&1 ; then
  # GNU ls supports --color
  alias ls="ls --color=auto"
else
  # --color not supported, assume BSD ls
  export CLICOLOR="true"
fi

# use emacs keybindings
bindkey -e
# keep vi-mode's Ctrl-W behavior
bindkey '^w' vi-backward-kill-word
# emulate the Ctrl-U behavior from bash
bindkey '^u' backward-kill-line
# add a keybinding to open the $EDITOR
autoload edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line
# file rename magick
bindkey "^[m" copy-prev-shell-word

# get shared history all working properly
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt share_history

autoload -U compinit && compinit
setopt complete_in_word
zstyle ':completion:*' menu select
# LS_COLORS set by dircolors above
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# case-insensitive (lower only), partial-word, and substring completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# fix Shift-Tab in the completions menu
bindkey '^[[Z' reverse-menu-complete

setopt notify # immediate job notifications
setopt extendedglob # crazy file globbing
setopt autopushd # cd works like pushd
autoload -U zmv

# get insert/delete/home/end working properly
# https://wiki.archlinux.org/index.php/Zsh#Key_Bindings
typeset -A key
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char

setopt prompt_subst
export PROMPT='%(?..%F{red}%? )%F{cyan}%M %F{blue}%~ %F{yellow}$(__git_ps1 "%s ")%f'

# defines __git_prompt for the prompt above
# Note: It doesn't generally work to source random files from oh-my-zsh, since
# they often depend on definitions from lib/, and we don't source those. This
# file is fine though -- it's copied from the core git project.
source "$DOTFILES/oh-my-zsh/plugins/gitfast/git-prompt.sh"

# Safe paste: give me a chance to edit multi-line commands that I paste in.
source "$DOTFILES/oh-my-zsh/plugins/safe-paste/safe-paste.plugin.zsh"

# Load work settings.
source "$DOTFILES/zshrc.keybase"

# Load settings specific to this machine.
local_zshrc="$HOME/.zshrc.local"
if [ -e "$local_zshrc" ] ; then
  source "$local_zshrc"
fi
