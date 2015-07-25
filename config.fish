setenv PATH ~/bin ~/.local/bin $PATH

if begin; [ "$TERM" = xterm ]; or [ "$TERM" = xterm-256color ]; end
  setenv SOLARIZED 1

  eval (dircolors -c ~/.dotfiles/dir_colors)

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
