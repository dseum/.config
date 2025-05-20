function rebuild -d "Rebuild with nix-darwin"
    set -lx HOMEBREW_NO_ANALYTICS 1
    set -lx HOMEBREW_NO_COLOR 1
    set -lx HOMEBREW_NO_ENV_HINTS 1
    sudo darwin-rebuild switch --flake $XDG_CONFIG_HOME/nix#main
end
