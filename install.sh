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
  dconf load / << END
[org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9]
foreground-color='#838394949696'
visible-name='Jack'
palette=['#070736364242', '#DCDC32322F2F', '#858599990000', '#B5B589890000', '#26268B8BD2D2', '#D3D336368282', '#2A2AA1A19898', '#EEEEE8E8D5D5', '#00002B2B3636', '#CBCB4B4B1616', '#58586E6E7575', '#65657B7B8383', '#838394949696', '#6C6C7171C4C4', '#9393A1A1A1A1', '#FDFDF6F6E3E3']
use-system-font=false
use-theme-colors=false
font='Ubuntu Mono 15'
bold-color-same-as-fg=false
bold-color='#9393a1a1a1a1'
background-color='#00002B2B3636'
audible-bell=false

[org/gnome/desktop/input-sources]
xkb-options=['caps:ctrl_modifier']
END
fi

if which gconftool-2 &> /dev/null ; then
  # terminal colors
  gnome-terminal-colors-solarized/set_dark.sh
  # terminal font
  gconftool-2 -s -t bool /apps/gnome-terminal/profiles/Default/use_system_font false
  gconftool-2 -s -t string /apps/gnome-terminal/profiles/Default/font "Ubuntu Mono 15"
fi

newshell=/usr/bin/zsh
if [ -e $newshell ] && [ $SHELL != $newshell ]; then
  echo Switching default shell from $SHELL to $newshell...
  chsh -s $newshell
fi

peru sync
