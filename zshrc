# Zsh doesn't read ~/.profile by default, but any environment variables we want
# to share with desktop programs (like gVim) need to live in that file.
emulate sh
source ~/.profile
emulate zsh

# Configure the prompt, which is implemented in Rust in this repo.
setopt PROMPT_SUBST
# Pass the exit status of the previous command as an argument.
PROMPT='$("$DOTFILES/prompt/target/release/prompt" $?)'

if [[ $XDG_SESSION_TYPE != tty ]] ; then
  export SOLARIZED=1
fi

alias ta='tmux attach'
alias grep='grep --color=auto'
alias i="ipython --no-confirm-exit"
alias i2="ipython2 --no-confirm-exit"
alias i3="ipython3 --no-confirm-exit"
if [[ -z "$(command -v open)" ]] ; then
  alias open="xdg-open"
fi
alias r='cd $(git rev-parse --show-toplevel || echo .)'
alias rp='cd $(realpath .)'
alias sz='source ~/.zshrc'
alias pypi_upload='python setup.py register sdist upload'
alias tohex="python3 -c 'import sys, binascii; print(binascii.hexlify(sys.stdin.buffer.read()).decode())'"
alias fromhex="python3 -c 'import sys, binascii; sys.stdout.buffer.write(binascii.unhexlify(input().strip()))'"
alias yolo="yay -Syu --noconfirm --removemake"
alias scu="systemctl --user"
alias jcu="journalctl --user"
alias timestamp="date +%Y-%m-%d-%H:%M:%S"
alias dr="docker run --tty --interactive --rm"
alias new="ls -lht --color=always | grep -Ev '^total' | head"
alias fa="fd -i --hidden --no-ignore"
alias ncdu="ncdu --color=off"

# git aliases
alias git="noglob git" # zsh likes to swallow ^ characters
alias gs='git status'
alias gd='git diff'
alias gca="git commit --amend --no-edit --all"
alias gcff="git clean -dffx"
alias grh='git reset --hard'
alias gout='git log "$(git_upstream_branch_name)".. --oneline'
alias goutp='git log "$(git_upstream_branch_name)".. -p'
alias ginit='git init && git add -A && git commit -m "first commit"'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --exclude=refs/stash --all'
alias gref='git reflog --all --date=relative'
alias gsub='git submodule update --init --recursive'
alias gfp='git fetch --all --tags --prune'
alias good='git bisect good'
alias bad='git bisect bad'
alias grecent='git for-each-ref --sort=-committerdate refs/heads/ --format="%(refname:short) (%(committerdate:relative))"'
alias gri='git rebase --interactive --autostash --update-refs "$(git merge-base "$(git_upstream_branch_name)" HEAD)"'
function gdrop() {
  local current_branch="$(git symbolic-ref --short HEAD)" &&
  git checkout "$(git_main_branch_name)" &&
  git branch -D "$current_branch" &&
}
function gup() {
  git fetch --all --tags --prune && \
  if [[ -n "$(git log HEAD.."$(git_upstream_branch_name)" -1)" ]] ; then
    git rebase "$(git_upstream_branch_name)" --autostash --update-refs
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
function git_main_branch_name() {
    if git rev-parse origin/main > /dev/null 2>&1 ; then
        echo main
        return 0
    elif git rev-parse origin/master > /dev/null 2>&1 ; then
        echo master
        return 0
    else
        echo "Can't figure out main branch name."
        return 1
    fi
}
function git_upstream_branch_name() {
    echo "origin/$(git_main_branch_name)"
}
alias ct='tmux show-buffer | c'
alias v='xclip -o -selection clipboard'
alias ri='rg -i'
alias ra='rg --hidden --no-ignore -L'
alias rai='rg --hidden --no-ignore -L -i'

# State-saving commands for git. The `git clean` at the end of the last two is
# to handle a weird bug where inner git directories aren't removed (though the
# files they contain are removed).
alias save='git add -A  && git commit --allow-empty -qnm "SAVE" && git reset --mixed -q HEAD^'
alias wipe='git add -A  && git commit --allow-empty -qnm "WIPE" && git reset --hard  -q HEAD^ && git clean -dqff'
alias nuke='git add -Af && git commit --allow-empty -qnm "NUKE" && git reset --hard  -q HEAD^ && git clean -dqffx'

alias deflate='python3 -c "import zlib,sys;sys.stdout.buffer.write(zlib.compress(sys.stdin.buffer.read()))"'
alias inflate='python3 -c "import zlib,sys;sys.stdout.buffer.write(zlib.decompress(sys.stdin.buffer.read()))"'

venv() {
  dir="$(mktemp -d --tmpdir venv.XXX)"
  echo "$dir (/tmp/venv)"
  ln -snf "$dir" /tmp/venv
  target_python="${1:-python}"
  real_python="$(basename "$(realpath "$(which "$target_python")")")"
  virtualenv "$dir" -p "$real_python" --prompt "[$real_python] "
  source "$dir/bin/activate"
}
alias vact="source /tmp/venv/bin/activate"

scratchdir() {
    mkdir -p /tmp/scratch
    mktemp -d --tmpdir="/tmp/scratch" "$1.XXX"
}

newgo() {
  dir="$(scratchdir go)"
  ln -sfn "$dir" /tmp/scratch/lastgo
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
  cat << EOF > go.mod
module test
EOF
  "$EDITOR" test.go
}

newrust() {
  crate="$(scratchdir rust)"
  ln -sfn "$crate" /tmp/scratch/lastrust
  cd "$crate"
  cargo init --bin --name scratch
  git add -A
  git commit -m "first"
  "$EDITOR" src/main.rs
}

newrustlib() {
  crate="$(scratchdir rustlib)"
  ln -sfn "$crate" /tmp/scratch/lastrustlib
  cd "$crate"
  cargo init --lib --name scratch
  git add -A
  git commit -m "first"
  "$EDITOR" src/lib.rs
}

newrustbench() {
  crate="$(scratchdir rustbench)"
  ln -sfn "$crate" /tmp/scratch/lastrustbench
  cd "$crate"
  cargo init --lib --name scratch
  mkdir benches
  cat /dev/null > src/lib.rs
  cat > benches/bench.rs << EOF
#![feature(test)]

extern crate test;

use test::Bencher;

#[bench]
fn bench(b: &mut Bencher) {
    b.iter(|| 1 + 1);
}
EOF
  cat > rust-toolchain.toml << EOF
[toolchain]
channel = "nightly"
EOF
  git add -A
  git commit -m "first"
  "$EDITOR" benches/bench.rs
}

newtokio() {
  crate="$(scratchdir tokio)"
  ln -sfn "$crate" /tmp/scratch/lasttokio
  cd "$crate"
  cargo init --bin --name scratch
  cargo add futures tokio --features tokio/full
  cat << EOF > src/main.rs
use tokio::time::{sleep, Duration};

#[tokio::main]
async fn main() {
    sleep(Duration::from_secs(1)).await;
    println!("done");
}
EOF
  git add -A
  git commit -m "first"
  setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR
  cargo build > /dev/null 2>&1 &
  "$EDITOR" src/main.rs
}

newcpp() {
  dir="$(scratchdir cpp)"
  ln -sfn "$crate" /tmp/scratch/lastcpp
  cd "$dir"
  ln -sfn "$DOTFILES/clang-format" .clang-format
  cat << EOF > scratch.cpp
#include <cstdint>
#include <print>
#include <string>
#include <vector>

int main() {
    std::println("{}", 42);
}
EOF
  cat << EOF > Makefile
run: scratch
	./scratch

scratch: scratch.cpp Makefile
	g++ scratch.cpp -o scratch -g -std=c++23 -fsanitize=undefined,address

clean:
	rm scratch
EOF
  git init
  git add -A
  git commit -m "first"
  "$EDITOR" scratch.cpp
}

newuv() {
  dir="$(scratchdir python)"
  ln -sfn "$dir" /tmp/scratch/lastpython
  cd "$dir"
  uv init --package --name scratch
  "$EDITOR" src/scratch/__init__.py
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
if [[ -n $SOLARIZED && -n "$(command -v dircolors)" ]] ; then
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

# Load work-related aliases and things.
source "$DOTFILES/zshrc.work"

# Load settings specific to this machine.
local_zshrc="$HOME/.zshrc.local"
if [ -e "$local_zshrc" ] ; then
  source "$local_zshrc"
fi

# FZF solarized colorscheme
# https://github.com/junegunn/fzf/wiki/Color-schemes#alternate-solarized-lightdark-theme
_gen_fzf_default_opts() {
  local base03="#002b36"
  local base02="#073642"
  local base01="#586e75"
  local base00="#657b83"
  local base0="#839496"
  local base1="#93a1a1"
  local base2="#eee8d5"
  local base3="#fdf6e3"
  local yellow="#b58900"
  local orange="#cb4b16"
  local red="#dc322f"
  local magenta="#d33682"
  local violet="#6c71c4"
  local blue="#268bd2"
  local cyan="#2aa198"
  local green="#859900"
  export FZF_DEFAULT_OPTS="
    --color fg:-1,bg:-1,hl:$blue,fg+:$base02,bg+:$base2,hl+:$blue
    --color info:$yellow,prompt:$yellow,pointer:$base03,marker:$base03,spinner:$yellow
  "
}
_gen_fzf_default_opts

# FZF keybinds (particularly ctrl-r for history search)
source "$DOTFILES/fzf/shell/key-bindings.zsh"
