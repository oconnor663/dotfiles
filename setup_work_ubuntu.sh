#! /bin/bash

set -exv

# oracle java
sudo add-apt-repository --yes ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java7-installer

# various devtools dependencies
sudo apt-get install g++ php5-cli php5-curl bison flex ant subversion ia32-libs-multiarch

mkdir ~/bin
mkdir ~/devtools
cd ~/devtools

# arc
git clone git://github.com/facebook/libphutil.git
git clone git://github.com/facebook/arcanist.git
libphutil/scripts/build_xhpast.sh
ln -s ~/devtools/arcanist/bin/arc ~/bin/arc

# Android SDK
wget http://dl.google.com/android/android-sdk_r21.1-linux.tgz
tar xf android-sdk_r21.1-linux.tgz
rm android-sdk_r21.1-linux.tgz
~/devtools/android-sdk-linux/tools/android &

# Android NDK
ndk=android-ndk-r8e # also used in .zshrc.local
ndkpkg=$ndk-linux-x86_64.tar.bz2
wget http://dl.google.com/android/ndk/$ndkpkg
tar xf $ndkpkg
rm $ndkpkg

# .zshrc.local
cat << END > ~/.zshrc.local
export ANDROID_SDK=~/devtools/android-sdk-linux
export ANDROID_SDK_ROOT=\$ANDROID_SDK
export ANDROID_HOME=\$ANDROID_SDK
export ANDROID_NDK=~/devtools/$ndk
export ANDROID_NDK_ROOT=\$ANDROID_NDK
export PATH=\$PATH:\$ANDROID_SDK/tools
export PATH=\$PATH:\$ANDROID_SDK/platform-tools
export PATH=\$PATH:\$ANDROID_NDK
export PATH=\$PATH:~/devtools/depot_tools
END
