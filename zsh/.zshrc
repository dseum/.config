# Options
setopt NO_CASE_GLOB
setopt PROMPT_SUBST
setopt AUTO_CD
setopt CORRECT
setopt CORRECT_ALL

# Environment
export PATH="$HOME/.flutter/bin:$PATH"
export PATH="$HOME/.volta/bin:$PATH"

# Prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b'

[[ $SSH_CONNECTION ]] && local host='@%m'
export NEWLINE=$'\n'
export PRE_PROMPT='%F{cyan}%B%~%b %U${vcs_info_msg_0_}%u%f'
export POST_PROMPT='%K{white}%F{black} %n${host} %#%f%k%F{white}%f '
export PROMPT="${PRE_PROMPT}${NEWLINE}${POST_PROMPT}"

update-prompt() {
    zle accept-line
    PROMPT="${POST_PROMPT}"
    zle reset-prompt
    PROMPT="${PRE_PROMPT}${NEWLINE}${POST_PROMPT}"
}
zle -N update-prompt
bindkey "^M" update-prompt

# Aliases
alias brewup="brew update && brew upgrade && brew doctor && brew cleanup"
alias tmat="tmux attach"
alias tmls="tmux ls"

# Completion
autoload -Uz compinit; compinit
[[ ! -r /Users/denniseum/.opam/opam-init/init.zsh ]] || source /Users/denniseum/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# `fzf`
export FZF_DEFAULT_COMMAND="fd --type file"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--prompt="— "
--pointer="—"
--marker="—"'
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
 --color=fg:#c0caf5,bg:#1a1b26,hl:#c0caf5
 --color=fg+:#c0caf5,bg+:#1a1b26,hl+:#c0caf5
 --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff
 --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a'

# `zoxide`
eval "$(zoxide init zsh)"
