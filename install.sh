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

for NAME in ${LINKED_FILES[*]} ; do
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
END
fi

newshell=/bin/zsh
if [ -e $newshell ] && [ $SHELL != $newshell ]; then
  echo Switching default shell from $SHELL to $newshell...
  chsh -s $newshell
fi
