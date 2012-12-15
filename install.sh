#!/bin/bash

relative_path=`dirname $0`
ROOT=`cd "$relative_path"; pwd`

DOTFILES=~/.dotfiles
DOTFILES_OLD=~/.dotfiles-old
ln -snf "$ROOT" "$DOTFILES"
mkdir -p "$DOTFILES_OLD"

LINKED_FILES=(
  bashrc
  gitconfig
  minttyrc
  pentadactylrc
  tmux.conf
  vim
  vimrc
  xinitrc
  xmobarrc
  xmonad
  Xresources
  Xresources.solarized
  zshrc
)

for NAME in ${LINKED_FILES[*]}
do
  DEST=~/".$NAME"

  # Copy existing dotfiles (but not symlinks) into the old directory
  if [ -e "$DEST" -a ! -L "$DEST" ]
  then
    mv "$DEST" "$DOTFILES_OLD/$NAME"
  fi

  ln -sfn "$ROOT/$NAME" "$DEST"
done

mkdir -p ~/.vim-tmp

if which gnome-terminal &> /dev/null
then
  "$ROOT/gnome-terminal-colors-solarized/set_dark.sh"
fi
