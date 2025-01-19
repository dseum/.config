# Options
setopt NO_CASE_GLOB
setopt PROMPT_SUBST
setopt AUTO_CD
setopt CORRECT
bindkey -v

# Variables
export VOLTA_HOME="$HOME/.volta"

# Path
export PATH="$HOME/.config/bin:$PATH"
export PATH="$VOLTA_HOME/bin:$PATH"

# Prompt
PROMPT=$'%{\e(0%}${(r:$COLUMNS::q:)}%{\e(B%}%F{cyan}%B%2~%b%f'$'\n''%K{white}%F{black} %n %f%k%F{white}%f '

# Aliases
alias tmat="tmux attach"
alias tmls="tmux ls"
alias fasrc="ssh deum@login.rc.fas.harvard.edu"
alias rebuild="HOMEBREW_NO_ENV_HINTS=1 HOMEBREW_NO_ANALYTICS=1 darwin-rebuild switch --flake $XDG_CONFIG_HOME/nix#main"

# fzf
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
