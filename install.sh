#!/bin/bash

set -e

HERE=$(cd $(dirname "$BASH_SOURCE"); pwd)

# Source the profile file immediately, for e.g. peru settings.
source "$HERE/profile"

if [[ "$HERE" != "$HOME/dotfiles" ]] ; then
  echo 'can only be installed from ~/dotfiles'
  exit 1
fi

newshell=/bin/zsh
if [ $SHELL != $newshell ]; then
  echo Switching default shell from $SHELL to $newshell...
  chsh -s $newshell
fi

peru sync

function link {
  local src="$1"
  local dest="$2"
  mkdir -p $(dirname "$dest")
  ln -sfn "$HERE/$src" "$dest"
}

link ackrc        ~/.ackrc
link gitconfig    ~/.gitconfig
link hgrc         ~/.hgrc
link makepkg.conf ~/.makepkg.conf
link profile      ~/.profile
link tmux.conf    ~/.tmux.conf
link tmux.desktop ~/.local/share/applications/tmux.desktop
link yaourtrc     ~/.yaourtrc
link vim          ~/.vim
link vim          ~/.config/nvim
link vimrc        ~/.vimrc
link vimrc        ~/.config/nvim/init.vim
link zshrc        ~/.zshrc

# Doing this in .vimrc is unnecessarily hard.
mkdir -p ~/.vim-tmp

for script in $(ls bin); do
  link "bin/$script" ~/bin/"$script"
done

# For Gnome, set terminal preferences and remap caps lock.
if which dconf &> /dev/null ; then
  dconf load / < $HERE/gnome-dconf-settings
fi
