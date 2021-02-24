if which nvim > /dev/null 2> /dev/null; then
  export EDITOR=nvim
else
  export EDITOR=vim
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
