#!/bin/bash

set -e

HERE=$(cd $(dirname "$BASH_SOURCE"); pwd)

if [[ "$HERE" != "$HOME/dotfiles" ]] ; then
  echo 'can only be installed from ~/dotfiles'
  exit 1
fi

peru sync

newshell=/usr/bin/fish
if [ $SHELL != $newshell ]; then
  echo Switching default shell from $SHELL to $newshell...
  chsh -s $newshell
fi

function link {
  local src="$1"
  local dest="$2"
  mkdir -p $(dirname "$dest")
  ln -sfn "$HERE/$src" "$dest"
}

link ackrc        ~/.ackrc
link config.fish  ~/.config/fish/config.fish
link gitconfig    ~/.gitconfig
link hgrc         ~/.hgrc
link ssh-config   ~/.ssh/config
link tmux.conf    ~/.tmux.conf
link tmux.desktop ~/.local/share/applications/tmux.desktop
link vim          ~/.vim
link vimrc        ~/.vimrc
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
