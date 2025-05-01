if status is-interactive
    # General
    set -g fish_key_bindings fish_vi_key_bindings
    set -g fish_cursor_default block
    set -g fish_cursor_insert block

    # Path
    fish_add_path -g "$XDG_CONFIG_HOME/bin"

    # fzf
    set -x FZF_DEFAULT_COMMAND "fd --type file"
    set -x FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS \
    --color=fg+:#c0caf5,bg+:#1a1b26,hl+:#c0caf5 \
    --color=fg:#c0caf5,bg:#1a1b26,hl:#c0caf5 \
    --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff \
    --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a \
    --info=inline-right \
    --marker='—' \
    --pointer='—' \
    --prompt='— ' \
    "
end
