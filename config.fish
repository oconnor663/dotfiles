set DOTFILES ~/dotfiles

set fish_greeting  # disable the greeting

setenv PATH ~/bin ~/.local/bin /usr/share/git/diff-highlight $PATH
setenv EDITOR vim
setenv PYTHONSTARTUP $DOTFILES/startup.py

# Set color variables and the solarized theme.
# TODO: This assumes that tmux will always be launched by a fish shell
# that has already exported these variables, so it won't need to set
# them again when $TERM=screen*. This should probably be less brittle.
if [ "$TERM" = xterm ]
  setenv TERM xterm-256color
end
if [ "$TERM" = xterm-256color ]
  setenv SOLARIZED 1
  eval (dircolors -c $DOTFILES/dircolors-solarized/dircolors.ansi-dark)
  source $DOTFILES/solarized.fish
end

function fish_prompt
  set -l last_status $status
  set -l prompt_status
  if test $last_status -ne 0
    set prompt_status " [$last_status]"
  end
  set -l user (whoami)@(hostname)
  echo -ns (set_color blue)(prompt_pwd) \
           (set_color yellow)(__fish_git_prompt " %s") \
           (set_color red) $prompt_status " " \
           (set_color normal) "> "
end

alias ta='tmux attach'
alias grep='grep --color=auto'
alias i="ipython --no-confirm-exit"
alias i2="ipython2 --no-confirm-exit"
alias i3="ipython3 --no-confirm-exit"
alias open="xdg-open"
alias r='cd (git rev-parse --show-toplevel; or echo .)'
alias c='xclip -i -selection clipboard'
alias ct='tmux show-buffer | c'
alias v='xclip -o -selection clipboard'
alias gs='git status'
alias gd='git diff'
alias gca="git commit -a --amend --no-edit"
alias gcff="git clean -dffx"
alias grh='git reset --hard'
alias gpr='git pull --rebase'
alias gfra='git fetch ;and git rebase --autostash'
alias gout='git log "@{upstream}.." --oneline'
alias ginit='git init ;and git add -A ;and git commit -m "first commit"'
