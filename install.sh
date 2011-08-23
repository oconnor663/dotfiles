#!/bin/bash

LINKED_FILES="\
  bashrc\
  dir_colors\
  vim\
  vimrc\
  "

for file in $LINKED_FILES
do
  ln -sf ~/dotfiles/$file ~/.$file
done
