#!/bin/bash

relative_path=`dirname $0`
path=`cd "$relative_path"; pwd`

ln -sfn "$path" ~/.dotfiles

LINKED_FILES=(
  bashrc
  gitconfig
  vim
  vimrc
  tmux.conf
)

for file in ${LINKED_FILES[*]}
do
  ln -sfn $path/$file ~/.$file
done

mkdir -p ~/.vim-tmp

which gnome-terminal 2> /dev/null
if [ $? -eq 0 ]
then
  "$path/gnome-terminal-colors-solarized/set_dark.sh"
fi
