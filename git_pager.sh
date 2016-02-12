#! /usr/bin/env bash

set -e -u -o pipefail

here="$(dirname "$BASH_SOURCE")"

highlight() {
  /usr/share/git/diff-highlight/diff-highlight
}

# Strip the leading + and - from diff output. Taken from
# https://github.com/stevemao/diff-so-fancy.
strip_leading_symbols() {
    color_code_regex=$'(\x1B\\[([0-9]{1,2}(;[0-9]{1,2})?)[m|K])?'
    sed -E "s/^$color_code_regex[\+\-]/\1 /g"
}

highlight | strip_leading_symbols | "$here/git_format.py" | less --tabs=1,5 -R
