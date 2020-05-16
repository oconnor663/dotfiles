# Zsh doesn't read ~/.profile by default, but any environment variables we want
# to share with desktop programs (like gVim) need to live in that file.
emulate sh
source ~/.profile
emulate zsh

if [[ $XDG_SESSION_TYPE != tty ]] ; then
  export SOLARIZED=1
fi

alias ta='tmux attach'
alias grep='grep --color=auto'
alias i="ipython --no-confirm-exit"
alias i2="ipython2 --no-confirm-exit"
alias i3="ipython3 --no-confirm-exit"
alias open="xdg-open"
alias r='cd $(git rev-parse --show-toplevel || echo .)'
alias rp='cd $(realpath .)'
alias find='noglob find' # easier wildcards
alias scp='noglob scp'   # ditto
alias sz='source ~/.zshrc'
alias pypi_upload='python setup.py register sdist upload'
alias tohex="python3 -c 'import sys, binascii; print(binascii.hexlify(sys.stdin.buffer.read()).decode())'"
alias fromhex="python3 -c 'import sys, binascii; sys.stdout.buffer.write(binascii.unhexlify(input().strip()))'"
alias yolo="yay -Syu --noconfirm --removemake"
alias scu="systemctl --user"
alias jcu="journalctl --user"
alias timestamp="date +%Y-%m-%d-%H:%M:%S"
alias dr="docker run --tty --interactive --rm"

# git aliases
alias git="noglob git" # zsh likes to swallow ^ characters
alias gs='git status'
alias gsi='git status --ignored'
alias gd='git diff'
alias gb='git rev-parse --abbrev-ref HEAD'
alias gcamend="git commit --amend --no-edit"
alias gca="gcamend -a"
alias gcff="git clean -dffx"
alias grh='git reset --hard'
alias gpr='git pull --rebase'
alias gfra='git fetch && git rebase --autostash origin/master'
alias gout='git log origin/master.. --oneline'
alias goutp='git log origin/master.. -p'
alias ginit='git init && git add -A && git commit -m "first commit"'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias gref='git reflog --all --date=relative'
alias gsub='git submodule update --init --recursive'
alias good='git bisect good'
alias bad='git bisect bad'
alias grecent='git for-each-ref --sort=-committerdate refs/heads/ --format="%(refname:short) (%(committerdate:relative))"'
function gdrop() {
  local current_branch="$(git symbolic-ref --short HEAD)" &&
  git checkout master &&
  git branch -D "$current_branch" &&
}
function gpo() {
  branch="$(git name-rev --name-only HEAD)"
  if [[ "$branch" = master ]] ; then
    echo "BLERG! Did you mean to run this on master?"
    return 1
  fi
  git push origin "$(git name-rev --name-only HEAD)" "$@"
}
function gup() {
  git fetch && \
  if [[ -n "$(git log HEAD..origin/master -1)" ]] ; then
    git rebase origin/master --autostash
  else
    echo Up to date.
  fi
}
function c() {
  if [ -t 0 ] && [ -z "$1" ] ; then
    echo "BLERG! Tried to copy terminal input."
    return 1
  fi
  xclip -i -selection clipboard "$@"
}
function hl() {
  # https://unix.stackexchange.com/a/367/23305
  grep --color -E "$1|$" "${@:2}"
}
alias ct='tmux show-buffer | c'
alias v='xclip -o -selection clipboard'
alias ri='rg -i'
alias gi='grep -i'

# State-saving commands for git. The `git clean` at the end of the last two is
# to handle a weird bug where inner git directories aren't removed (though the
# files they contain are removed).
alias save='git add -A  && git commit --allow-empty -qnm "SAVE" && git reset --mixed -q HEAD^'
alias wipe='git add -A  && git commit --allow-empty -qnm "WIPE" && git reset --hard  -q HEAD^ && git clean -dqff'
alias nuke='git add -Af && git commit --allow-empty -qnm "NUKE" && git reset --hard  -q HEAD^ && git clean -dqffx'

alias deflate='python3 -c "import zlib,sys;sys.stdout.buffer.write(zlib.compress(sys.stdin.buffer.read()))"'
alias inflate='python3 -c "import zlib,sys;sys.stdout.buffer.write(zlib.decompress(sys.stdin.buffer.read()))"'

venv() {
  dir="$(mktemp -d)"
  target_python="${1:-python}"
  real_python="$(basename "$(realpath "$(which "$target_python")")")"
  virtualenv "$dir" -p "$real_python" --prompt "[$real_python] "
  source "$dir/bin/activate"
}

newgo() {
  dir="$(mktemp -d)"
  ln -sfn "$dir" /tmp/lastgo
  cd "$dir"
  cat << EOF > test.go
package main

import (
	"fmt"
)

func main() {
	fmt.Println("hello")
}
EOF
  "$EDITOR" test.go
}

newrust() {
  crate="$(mktemp -d)"/scratch
  ln -sfn "$crate" /tmp/lastrust
  cargo new --bin "$crate"
  cd "$crate"
  git add -A
  git commit -m "first"
  "$EDITOR" src/main.rs
}

cbturbo() {
  if [[ "$(cat /sys/devices/system/cpu/intel_pstate/no_turbo)" != 0 ]] ; then
    echo "TurboBoost is already off." 1>&2
    return 1
  fi
  BUILD_ARGS=()
  for arg in "$@" ; do
    if [[ "$arg" = --features* || "$arg" = --all-features || "$arg" = --no-default-features ]] ; then
      BUILD_ARGS+=("$arg")
    fi
  done
  cargo +nightly build --benches --release "$BUILD_ARGS[@]" || return $?
  restore() {
    if [[ "$(cat /sys/devices/system/cpu/intel_pstate/no_turbo)" != 0 ]] ; then
      echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo > /dev/null
      echo "--- TurboBoost on. ---"
    fi
  }
  trap restore EXIT INT TERM
  echo "--- TurboBoost off. ---"
  echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo > /dev/null
  cargo +nightly bench "$@"
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
HISTSIZE=100000
SAVEHIST=$HISTSIZE
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt share_history

# use regexes in history search
bindkey '^r' history-incremental-pattern-search-backward
bindkey '^s' history-incremental-pattern-search-forward

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
if [[ -n $SOLARIZED ]] ; then
  export PROMPT='%(?..%F{red}%? )%F{cyan}%M %F{blue}%~ %F{yellow}$(__git_ps1 "%s ")%f'
else
  # Bold blue is more visible in the Linux console.
  export PROMPT='%(?..%F{red}%? )%F{cyan}%M %B%F{blue}%~%b %F{yellow}$(__git_ps1 "%s ")%f'
fi

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
