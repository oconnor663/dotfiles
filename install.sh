#!/bin/bash

set -e

cd `dirname $0`
ROOT=`pwd`

DOTFILES=~/.dotfiles
DOTFILES_OLD=~/.dotfiles-old
ln -snf "$ROOT" "$DOTFILES"
mkdir -p "$DOTFILES_OLD"

LINKED_PATHS=(
  ackrc
  bashrc
  gitconfig
  hgrc
  minttyrc
  ssh/config
  tmux.conf
  vim
  vimrc
  zshrc
  xinitrc
  xmobarrc
  xmonad/xmonad.hs
  Xresources
)

for NAME in ${LINKED_PATHS[*]} ; do
  DEST=~/".$NAME"

  # Copy existing dotfiles (but not symlinks) into the old directory
  if [ -e "$DEST" -a ! -L "$DEST" ]
  then
    mkdir -p $(dirname "$DOTFILES_OLD/$NAME")
    mv "$DEST" "$DOTFILES_OLD/$NAME"
  fi

  mkdir -p $(dirname "$DEST")
  ln -sfn "$ROOT/$NAME" "$DEST"
done

mkdir -p ~/bin
for script in `ls bin`; do
  ln -sfn "$ROOT/bin/$script" ~/bin/"$script"
done

mkdir -p ~/.vim-tmp

mkdir -p ~/.local/share/applications
ln -sf $DOTFILES/tmux.desktop ~/.local/share/applications/tmux.desktop

# For Gnome, set terminal preferences and remap caps lock.
if which dconf &> /dev/null ; then
  dconf load / < $DOTFILES/gnome-dconf-settings
fi

newshell=/usr/bin/zsh
if [ -e $newshell ] && [ $SHELL != $newshell ]; then
  echo Switching default shell from $SHELL to $newshell...
  chsh -s $newshell
fi

peru sync
