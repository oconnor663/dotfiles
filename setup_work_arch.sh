#! /bin/bash

is_installed() {
  pacman -Q $1 > /dev/null
}

install_aur_once() {
  if ! is_installed $1 ; then
    yaourt -S --noconfirm $1
  else
    echo $1 is already installed. Skipping.
  fi
}

clone_once() {
  if [ ! -e "$2" ] ; then
    git clone "$1" "$2"
    cloned=true
  else
    echo $2 already exists. Skipping.
    cloned=false
  fi
}

set -exv

# default to Python2
ln -sf /usr/bin/python2 ~/bin/python

# add [multilib] in pacman.conf
if ! grep '^\[multilib\]$' /etc/pacman.conf ; then
  sudo cat >> /etc/pacman.conf << END

# Added by Jack's env setup
[multilib]
Include = /etc/pacman.d/mirrorlist
END
  sudo pacman -Sy
fi

# oracle java 7
install_aur_once jdk

# various dependencies
sudo pacman -S --needed --noconfirm php apache-ant
if ! is_installed subversion-1.6 ; then
  sudo pacman -S --needed --noconfirm subversion
fi

# Android SDK and NDK
install_aur_once android-sdk
install_aur_once android-ndk

mkdir -p ~/bin
mkdir -p ~/devtools

# arc
clone_once git://github.com/facebook/libphutil.git ~/devtools/libphutil
clone_once git://github.com/facebook/arcanist.git ~/devtools/arcanist
if $cloned ; then
  ~/devtools/libphutil/scripts/build_xhpast.sh
  ln -sf ~/devtools/arcanist/bin/arc ~/bin/arc
fi

# .zshrc.local
cat << END > ~/.zshrc.local
export PATH=\$PATH:\$ANDROID_HOME/platform-tools
export PATH=\$PATH:~/devtools/depot_tools
END
