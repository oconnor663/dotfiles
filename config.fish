set DOTFILES ~/dotfiles

setenv PATH ~/bin ~/.local/bin $PATH
setenv EDITOR vim
setenv PYTHONSTARTUP $DOTFILES/startup.py

if begin; [ "$TERM" = xterm ]; or [ "$TERM" = xterm-256color ]; end
  setenv SOLARIZED 1

  eval (dircolors -c $DOTFILES/dircolors-solarized/dircolors.ansi-dark)

  ###
  ### TODO: Factor out these colors somehow.
  ###

  set -l base03  "--bold black"
  set -l base02  "black"
  set -l base01  "--bold green"
  set -l base00  "--bold yellow"
  set -l base0   "--bold blue"
  set -l base1   "--bold cyan"
  set -l base2   "white"
  set -l base3   "--bold white"
  set -l yellow  "yellow"
  set -l orange  "--bold red"
  set -l red     "red"
  set -l magenta "magenta"
  set -l violet  "--bold magenta"
  set -l blue    "blue"
  set -l cyan    "cyan"
  set -l green   "green"

  # Used by fish's completion; see
  # http://fishshell.com/docs/2.0/index.html#variables-color

  set -g fish_color_normal      $base0
  set -g fish_color_command     $base0
  set -g fish_color_quote       $cyan
  set -g fish_color_redirection $base0
  set -g fish_color_end         $base0
  set -g fish_color_error       $red
  set -g fish_color_param       $blue
  set -g fish_color_comment     $base01
  set -g fish_color_match       $cyan
  set -g fish_color_search_match "--background=$base02"
  set -g fish_color_operator    $orange
  set -g fish_color_escape      $cyan

  # Used by fish_prompt

  set -g fish_color_hostname    $cyan
  set -g fish_color_cwd         $yellow
  set -g fish_color_git         $green

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
