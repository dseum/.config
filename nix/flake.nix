{
  description = "nix-darwin system flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };
  outputs =
    inputs@{
      self,
      nix-darwin,
      nix-homebrew,
      nixpkgs,
    }:
    let
      configuration =
        { pkgs, config, ... }:
        let
          paths = {
            home = "/Users/denniseum";
            config = "/Users/denniseum/.config";
          };
        in
        {
          environment = {
            etc."pam.d/sudo_local".text = ''
              auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
              auth       sufficient     pam_tid.so
            '';
            shells = [
              pkgs.zsh
            ];
            systemPackages = [
              pkgs.appcleaner
              pkgs.buf
              pkgs.cmake
              pkgs.cmake-format
              pkgs.dafny
              pkgs.dotnetCorePackages.dotnet_8.sdk
              pkgs.fd
              pkgs.fzf
              pkgs.go
              pkgs.google-chrome
              (pkgs.neovim.override {
                viAlias = true;
                vimAlias = true;
              })
              pkgs.ninja
              pkgs.nixfmt-rfc-style
              pkgs.ollama
              pkgs.opam
              pkgs.pam-reattach
              (pkgs.python2Full.withPackages (
                ps: with ps; [
                  pip
                  setuptools
                  wheel
                ]
              ))
              pkgs.python312Full
              pkgs.ripgrep
              pkgs.rustup
              pkgs.slack
              pkgs.spotify
              pkgs.sqlc
              pkgs.tex-fmt
              pkgs.texliveFull
              pkgs.tmux
              pkgs.uv
              pkgs.volta
              pkgs.vscode
              pkgs.wget
              pkgs.zoom-us
            ];
          };
          fonts.packages = [
            pkgs.jetbrains-mono
          ];
          homebrew = {
            enable = true;
            brews = [
              "autoconf"
              "automake"
              "autoconf-archive"
              "llvm@18"
              "ghcup"
              "gsl"
              "libtool"
              "pkg-config"
            ];
            casks = [
              "1password"
              "ghostty"
              "orbstack"
            ];
            masApps = {
              "Goodnotes 6" = 1444383602;
              "KakaoTalk" = 869223134;
              "Messenger" = 1480068668;
              "SurfShark" = 1437809329;
              "Todoist" = 585829637;
              "WhatsApp" = 310633997;
            };
            onActivation.autoUpdate = true;
            onActivation.cleanup = "zap";
            onActivation.upgrade = true;
          };
          networking = {
            knownNetworkServices = [
              "Wi-Fi"
            ];
            dns = [
              "1.1.1.1"
              "1.0.0.1"
              "2606:4700:4700::1111"
              "2606:4700:4700::1001"
            ];
            hostName = "Denniss-MacBook-Pro";
          };
          nix = {
            gc.automatic = true;
            settings = {
              auto-optimise-store = true;
              experimental-features = [
                "nix-command"
                "flakes"
              ];
            };
          };
          nixpkgs = {
            hostPlatform = "aarch64-darwin";
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                "python-2.7.18.8"
                "python-2.7.18.8-env"
              ];
            };
          };
          power.sleep = {
            computer = 20;
            display = 15;
          };
          programs.zsh = {
            enable = true;
            enableGlobalCompInit = true;
            enableBashCompletion = true;
            shellInit = ''
              export XDG_CACHE_HOME="$HOME/.cache"
              export XDG_CONFIG_HOME="$HOME/.config"
              export XDG_DATA_HOME="$HOME/.local/share"
              export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
              export EDITOR="nvim"
              export VISUAL="nvim"
            '';
          };
          services = {
            skhd.enable = true;
            yabai = {
              enable = true;
              enableScriptingAddition = true;
            };
          };
          system = {
            activationScripts.applications.text =
              let
                env = pkgs.buildEnv {
                  name = "system-applications";
                  paths = config.environment.systemPackages;
                  pathsToLink = "/Applications";
                };
              in
              pkgs.lib.mkForce ''
                echo "setting up apps..." >&2
                find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
                while read -r app_src; do
                  app_name=$(basename -s ".app" "$app_src")
                  echo "copying $app_name" >&2
                  cp -R "$app_src" "/Applications"
                  icns_src="${paths.config}/icons/$app_name.icns"
                  if [ -f "$icns_src" ]; then
                    icns_tgt=$(find "/Applications/$app_name.app/Contents/Resources" -name "*.icns")
                    cp "$icns_src" "$icns_tgt"
                  fi
                done
                echo "resetting icons..." >&2
                rm -rf /Library/Caches/com.apple.iconservices.store 2>/dev/null
                find /private/var/folders/ \( -name com.apple.dock.iconcache -or -name com.apple.iconservices \) -exec rm -rf {} \; 2>/dev/null
                killall Finder
                killall Dock
              '';
            configurationRevision = self.rev or self.dirtyRev or null;
            defaults = {
              dock = {
                autohide = true;
                persistent-apps = [
                  "/Applications/Zen.app"
                  "/System/Applications/Mail.app"
                  "/System/Applications/Calendar.app"
                  "/Applications/Todoist.app"
                  "/Applications/Spotify.app"
                  "/Applications/Ghostty.app"
                  "/Applications/Visual Studio Code.app"
                  "/Applications/Slack.app"
                  "/Applications/KakaoTalk.app"
                  "/Applications/WhatsApp.app"
                  "/Applications/Messenger.app"
                  "/System/Applications/System Settings.app"
                ];
                show-recents = false;
                universalaccess.reduceMotion = true;
              };
              finder = {
                AppleShowAllExtensions = true;
                AppleShowAllFiles = false;
                CreateDesktop = false;
                FXEnableExtensionChangeWarning = false;
                FXPreferredViewStyle = "clmv";
                FXRemoveOldTrashItems = true;
                ShowPathbar = false;
                ShowStatusBar = false;
              };
              loginwindow.GuestEnabled = false;
              WindowManager = {
                EnableStandardClickToShowDesktop = false;
                GloballyEnabled = false;
                StandardHideDesktopIcons = false;
              };
            };
            keyboard = {
              enableKeyMapping = true;
              remapCapsLockToEscape = true;
            };
            stateVersion = 6;
          };
        };
    in
    {
      darwinConfigurations."main" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "denniseum";
            };
          }
        ];
      };
    };
}
