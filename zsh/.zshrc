# Options
setopt NO_CASE_GLOB
setopt PROMPT_SUBST
setopt AUTO_CD
setopt CORRECT
bindkey -v
zstyle ':completion:*' list-prompt ''
zstyle ':completion:*' select-prompt ''

# Path
export PATH="$XDG_CONFIG_HOME/bin:$PATH"

# Prompt
PROMPT=$'%F{#787e9c}${(r:$COLUMNS::\u2500:)}%f\n%F{cyan}%B%2~%b%f\n%K{white}%F{black} %n %f%k%F{white}%f '

# Rebuild
alias rebuild="HOMEBREW_NO_ENV_HINTS=1 HOMEBREW_NO_ANALYTICS=1 sudo darwin-rebuild switch --flake $XDG_CONFIG_HOME/nix#main"

# fzf
export FZF_DEFAULT_COMMAND="fd --type file"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
--color=fg+:#c0caf5,bg+:#1a1b26,hl+:#c0caf5 \
--color=fg:#c0caf5,bg:#1a1b26,hl:#c0caf5 \
--color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff \
--color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a \
--info=inline-right \
--marker='—' \
--pointer='—' \
--prompt='— ' \
"
