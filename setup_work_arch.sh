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
mkdir -p ~/bin
ln -sf /usr/bin/python2 ~/bin/python
ln -sf /usr/bin/python2 ~/bin/python2.6

# add [multilib] in pacman.conf
if ! grep '^\[multilib\]$' /etc/pacman.conf ; then
  sudo tee -a /etc/pacman.conf << END

# Added by Jack's env setup
[multilib]
Include = /etc/pacman.d/mirrorlist
END
  sudo pacman -Sy
fi

# oracle java 7
install_aur_once jdk

# various dependencies
sudo pacman -S --needed --noconfirm php apache-ant intellij-idea-community-edition
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
# allow PHP to run outside of web directories
sudo sed -i 's/^open_basedir = /; open_basedir = /' /etc/php/php.ini
# enable posix extensions
sudo sed -i 's/;extension=posix.so/extension=posix.so/' /etc/php/php.ini
if $cloned ; then
  ~/devtools/libphutil/scripts/build_xhpast.sh
  ln -sf ~/devtools/arcanist/bin/arc ~/bin/arc
fi

# .zshrc.local
cat << END > ~/.zshrc.local
export PATH=\$PATH:\$ANDROID_HOME/platform-tools
export PATH=\$PATH:~/devtools/depot_tools
END

# vpn
sudo pacman -S --needed --noconfirm openconnect
cat > ~/bin/vpn << END
#! /bin/bash

sudo openconnect -u jacko -c ~/keys/client.pem \
  --cafile ~/keys/TheFacebookRootCA.pem \
  https://prnasa.tfbnw.net
END
chmod 755 ~/bin/vpn
