set-option global scrolloff 1,0

add-highlighter global/ show-whitespaces -tab → -spc " " -lf " "

# fzf commands from https://github.com/mawww/kakoune/wiki/Fuzzy-finder#fzf
define-command -docstring 'Invoke fzf to open a file' -params 0 fzf-edit %{
    evaluate-commands %sh{
        if [ -z "${kak_client_env_TMUX}" ]; then
            printf 'fail "client was not started under tmux"\n'
        else
            file="$(find . -type f |TMUX="${kak_client_env_TMUX}" fzf-tmux -d 15)"
            if [ -n "$file" ]; then
                printf 'edit "%s"\n' "$file"
            fi
        fi
    }
}
define-command -docstring 'Invoke fzf to select a buffer' fzf-buffer %{
    evaluate-commands %sh{
        BUFFER=$(
            (
                eval "set -- $kak_buflist"
                while [ $# -gt 0 ]; do
                    printf "%s\0" "$1"
                    shift
                done
            ) |
            fzf-tmux -d 15 --read0
        )
        BUFFER=${BUFFER/\'/\'\'}
        if [ -n "$BUFFER" ]; then
            printf "buffer '%s'" "${BUFFER}"
        fi
    }
}

# mappings for the fzf commands above
map global user e ':fzf-edit<ret>'
map global user b ':fzf-buffer<ret>'
