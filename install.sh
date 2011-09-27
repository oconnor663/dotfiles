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
  rm ~/.$file
  ln -s ~/dotfiles/$file ~/.$file
done
