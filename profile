if which kak > /dev/null ; then
  export EDITOR=kak
else
  export EDITOR=vi
fi

export GOPATH=~/go
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$GOPATH/bin:$PATH"

# Centralize all peru caching.
export PERU_CACHE_DIR="$HOME/.peru-cache"

export DOTFILES="$HOME/dotfiles"

export BAT_THEME="Solarized (dark)"

if [ -e ~/.profile.local ] ; then
    source ~/.profile.local
fi
