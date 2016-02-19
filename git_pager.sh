#! /usr/bin/env bash

set -e -u -o pipefail

here="$(dirname "$BASH_SOURCE")"

highlight() {
  /usr/share/git/diff-highlight/diff-highlight
}

highlight | "$here/git_format.py" | less --tabs=1,5 -R
