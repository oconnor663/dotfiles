if which nvim > /dev/null ; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH="$HOME/rust/src"

# Centralize all peru caching.
export PERU_CACHE_DIR="$HOME/.peru-cache"

export DOTFILES="$HOME/dotfiles"
export PYTHONSTARTUP="$DOTFILES/startup.py"

export RUST_BACKTRACE=1

source "$DOTFILES/profile.keybase"

if [ -e ~/.profile.local ] ; then
    source ~/.profile.local
fi
