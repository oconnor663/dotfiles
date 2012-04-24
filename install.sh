#!/bin/bash

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
  ln -sf ~/dotfiles/$file ~/.$file
done

mkdir ~/.vim/_backup
mkdir ~/.vim/_temp
