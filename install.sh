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

link alacritty.yml      ~/.config/alacritty/alacritty.yml
link docker_config.json ~/.docker/config.json
link gdbinit            ~/.gdbinit
link gitconfig          ~/.gitconfig
link hgrc               ~/.hgrc
link makepkg.conf       ~/.makepkg.conf
link profile            ~/.profile
link starship.toml      ~/.config/starship.toml
link tmux.conf          ~/.tmux.conf
link tmux.desktop       ~/.local/share/applications/tmux.desktop
link vimrc              ~/.config/nvim/init.vim
link vim_pack           ~/.local/share/nvim/site/pack
link zshrc              ~/.zshrc

for script in $(ls bin); do
  link "bin/$script" ~/bin/"$script"
done
