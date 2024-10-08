# Options
setopt NO_CASE_GLOB
setopt PROMPT_SUBST
setopt AUTO_CD
setopt CORRECT

# Environment
export PATH="$HOME/.flutter/bin:$PATH"
export PATH="$HOME/.volta/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="$HOME/.go/bin:$PATH"

# Prompt
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%b'

precmd() {
    vcs_info 
    precmd() {
        print
        vcs_info 
    }
}

[[ $SSH_CONNECTION ]] && local host='@%m'
export PROMPT='%F{cyan}%B%2~%b %U${vcs_info_msg_0_}%u%f'$'\n''%K{white}%F{black} %n${host} %#%f%k%F{white}%f '

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
