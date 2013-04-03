#!/bin/bash

cd `dirname $0`
ROOT=`pwd`

DOTFILES=~/.dotfiles
DOTFILES_OLD=~/.dotfiles-old
ln -snf "$ROOT" "$DOTFILES"
mkdir -p "$DOTFILES_OLD"

LINKED_FILES=(
  bashrc
  gitconfig
  hgrc
  minttyrc
  tmux.conf
  vim
  vimrc
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

# Run our startup script on boot
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/DotfilesStartup.desktop << END
[Desktop Entry]
Type=Application
Name=Dotfiles Startup
Exec=$ROOT/startup.sh
END
# And run it now for good measure
./startup.sh

# Enable this when we need to symlink desktop config files
# find config -type d -exec mkdir -p ~/.{} \;
# find config -type f -exec ln -s "$ROOT/{}" ~/.{} \;

mkdir -p ~/.vim-tmp

if which gnome-terminal &> /dev/null
then
  # terminal colors
  gnome-terminal-colors-solarized/set_dark.sh
  # terminal font
  gconftool-2 -s -t bool /apps/gnome-terminal/profiles/Default/use_system_font false
  gconftool-2 -s -t string /apps/gnome-terminal/profiles/Default/font "Ubuntu Mono 15"
fi
