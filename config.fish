set DOTFILES ~/dotfiles

set fish_greeting  # disable the greeting

setenv PATH ~/bin ~/.local/bin $PATH
setenv EDITOR vim
setenv PYTHONSTARTUP $DOTFILES/startup.py

if begin; [ "$TERM" = xterm ]; or [ "$TERM" = xterm-256color ]; end
  setenv SOLARIZED 1
  eval (dircolors -c $DOTFILES/dircolors-solarized/dircolors.ansi-dark)

  # Copied from the output of fish_config.
  setenv fish_color_autosuggestion 586e75
  setenv fish_color_command 93a1a1
  setenv fish_color_comment 586e75
  setenv fish_color_cwd green
  setenv fish_color_cwd_root red
  setenv fish_color_end 268bd2
  setenv fish_color_error dc322f
  setenv fish_color_escape cyan
  setenv fish_color_history_current cyan
  setenv fish_color_match cyan
  setenv fish_color_normal normal
  setenv fish_color_operator cyan
  setenv fish_color_param 839496
  setenv fish_color_quote 657b83
  setenv fish_color_redirection 6c71c4
  setenv fish_color_search_match \x2d\x2dbackground\x3dpurple
  setenv fish_color_selection \x2d\x2dbackground\x3dpurple
  setenv fish_color_valid_path \x2d\x2dunderline
  setenv fish_key_bindings fish_default_key_bindings
  setenv fish_pager_color_completion normal
  setenv fish_pager_color_description 555\x1eyellow
  setenv fish_pager_color_prefix cyan
  setenv fish_pager_color_progress cyan
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
