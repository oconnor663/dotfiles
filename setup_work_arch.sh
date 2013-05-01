#! /bin/bash

is_installed() {
  pacman -Qsq $1 | grep "^$1$" > /dev/null
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
sudo ln -sf python2 /usr/bin/python

# uncomment [multilib] in pacman.conf
tmp=`mktemp`
cat /etc/pacman.conf | perl -00 -pne 's/#\[multilib\]\n#Include = \/etc\/pacman.d\/mirrorlist/\[multilib\]\nInclude = \/etc\/pacman.d\/mirrorlist/' > $tmp
sudo mv $tmp /etc/pacman.conf
sudo pacman -Sy

# oracle java 7
install_aur_once jdk

# various dependencies
sudo pacman -S --needed --noconfirm php apache-ant subversion

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
