#!/bin/bash

relative_path=`dirname $0`
path=`cd $relative_path; pwd`

LINKED_FILES="\
  bashrc\
  dir_colors\
  gitconfig\
  vim\
  vimrc\
  tmux.conf\
  "

for file in $LINKED_FILES
do
  ln -sf $path/$file ~/.$file
done

mkdir -p ~/.vim-tmp

if [ -n `which gnome-terminal` ]
then
  $path/gnome-terminal-colors-solarized/set_dark.sh
fi
