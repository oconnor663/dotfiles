#!/bin/bash

set -e

HERE=$(cd $(dirname "$BASH_SOURCE"); pwd)

cd "$HERE"

# Source the profile file immediately, for e.g. peru settings.
source "$HERE/profile"

if [[ "$HERE" != "$HOME/dotfiles" ]] ; then
  echo 'can only be installed from ~/dotfiles'
  exit 1
fi

newshell=/bin/zsh
if [ $SHELL != $newshell ]; then
  echo Switching default shell from $SHELL to $newshell...
  chsh -s $newshell
fi

peru sync

function link {
  local src="$1"
  local dest="$2"
  mkdir -p $(dirname "$dest")
  ln -sfn "$HERE/$src" "$dest"
}

link ackrc         ~/.ackrc
link alacritty.yml ~/.config/alacritty/alacritty.yml
link gitconfig     ~/.gitconfig
link hgrc          ~/.hgrc
link makepkg.conf  ~/.makepkg.conf
link profile       ~/.profile
link tmux.conf     ~/.tmux.conf
link tmux.desktop  ~/.local/share/applications/tmux.desktop
link yaourtrc      ~/.yaourtrc
link vim           ~/.vim
link vim           ~/.config/nvim
link vimrc         ~/.vimrc
link vimrc         ~/.config/nvim/init.vim
link zshrc         ~/.zshrc

link keybindings.json ~/.config/Code/User/keybindings.json
link settings.json    ~/.config/Code/User/settings.json

# Doing this in .vimrc is unnecessarily hard.
mkdir -p ~/.vim-tmp

for script in $(ls bin); do
  link "bin/$script" ~/bin/"$script"
done

# For Gnome, set terminal preferences and remap caps lock.
if which dconf &> /dev/null ; then
  dpi_setting="/org/gnome/settings-daemon/plugins/xsettings/overrides"
  dpi_value="'Gdk/WindowScalingFactor': <2>"
  if dconf read "$dpi_setting" | grep "$dpi_value" > /dev/null ; then
    echo "2x DPI scaling detected. Using smaller terminal font size."
    font_size=12
  else
    echo "No DPI scaling detected. Using larger terminal font size."
    font_size=15
  fi
  sed "s/@@FONTSIZE@@/$font_size/" $HERE/gnome-dconf-settings.template | dconf load /
fi
