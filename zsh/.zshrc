# Environment
export PATH="$HOME/.flutter/bin:$PATH"
export PATH="$HOME/.volta/bin:$PATH"

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

# `zsh` Prompt
function parse_git_branch() {
    git branch --show-current 2> /dev/null | sed "s/^\(.*\)/[\1] /"
}

setopt PROMPT_SUBST
export PROMPT='%n@%m %1~ $(parse_git_branch)%# '

# Aliases
alias brewup="brew update && brew upgrade && brew doctor && brew cleanup"
alias tmat="tmux attach"
alias tmls="tmux ls"

# Completions
[[ ! -r /Users/denniseum/.opam/opam-init/init.zsh ]] || source /Users/denniseum/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
autoload -U compinit; compinit
