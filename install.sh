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

(cd vim_pack/coc/start/coc && yarn install --frozen-lockfile)

function link {
  local src="$1"
  local dest="$2"
  mkdir -p $(dirname "$dest")
  ln -sfn "$HERE/$src" "$dest"
}

link ackrc              ~/.ackrc
link alacritty.yml      ~/.config/alacritty/alacritty.yml
link coc-settings.json  ~/.config/nvim/coc-settings.json
link docker_config.json ~/.docker/config.json
link gitconfig          ~/.gitconfig
link hgrc               ~/.hgrc
link kakrc              ~/.config/kak/kakrc
link kak-autoload       ~/.config/kak/autoload
link kitty.conf         ~/.config/kitty/kitty.conf
link makepkg.conf       ~/.makepkg.conf
link profile            ~/.profile
link starship.toml      ~/.config/starship.toml
link tmux.conf          ~/.tmux.conf
link tmux.desktop       ~/.local/share/applications/tmux.desktop
link yaourtrc           ~/.yaourtrc
link vimrc              ~/.config/nvim/init.vim
link vim_pack           ~/.local/share/nvim/site/pack
link zshrc              ~/.zshrc

for script in $(ls bin); do
  link "bin/$script" ~/bin/"$script"
done

# For Gnome, set terminal preferences and remap caps lock.
if which dconf &> /dev/null ; then
  dconf load / < "$HERE/gnome-dconf-settings"
fi
