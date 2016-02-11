#! /usr/bin/env bash

set -e -u -o pipefail

highlight() {
  /usr/share/git/diff-highlight/diff-highlight
}

add_box() {
  top="┌───────────────────────────────────────────────┐"
  bottom="└───────────────────────────────────────────────┘"
  wall="│"
  sed -E "s/^\\S*(commit \\w{40})/$top\\n$wall\\1$wall/" | \
    sed -E "s/^(Author:.*)/$wall\\1$wall/" | \
    sed -E "s/^(Date:.*)/$wall\\1$wall\\n$bottom/"
}

highlight | add_box | less --tabs=1,5 -R
