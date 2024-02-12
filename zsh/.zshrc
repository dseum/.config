# Options
setopt NO_CASE_GLOB
setopt PROMPT_SUBST
setopt AUTO_CD
setopt CORRECT
setopt CORRECT_ALL

# Environment
export PATH="$HOME/.flutter/bin:$PATH"
export PATH="$HOME/.volta/bin:$PATH"

# Aliases
alias brewup="brew update && brew upgrade && brew doctor && brew cleanup"
alias tmat="tmux attach"
alias tmls="tmux ls"

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

# Prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '

[[ $SSH_CONNECTION ]] && local user='%n@%m '
export PROMPT='%K{white}%F{black} ${user}%B%3~%b ${vcs_info_msg_0_}%#%f%k%F{white}%f '

# Completion
autoload -Uz compinit; compinit
[[ ! -r /Users/denniseum/.opam/opam-init/init.zsh ]] || source /Users/denniseum/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
