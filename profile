export EDITOR=vim
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH="$HOME/rust/src"

# Centralize all peru caching.
export PERU_CACHE_DIR="$HOME/.peru-cache"

export DOTFILES="$HOME/dotfiles"
export PYTHONSTARTUP="$DOTFILES/startup.py"

if [ -e ~/.profile.local ] ; then
    source ~/.profile.local
fi
