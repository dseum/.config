{
  description = "nix-darwin system flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };
  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
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
              pkgs.cocoapods
              pkgs.dafny
              pkgs.dotnetCorePackages.dotnet_8.sdk
              pkgs.fd
              pkgs.fzf
              pkgs.go
              pkgs.google-chrome
              (pkgs.llvmPackages_19.clangUseLLVM.override {
                libcxx = pkgs.llvmPackages_19.libcxxStdenv;
              })
              pkgs.llvmPackages_19.clang-tools
              (pkgs.neovim.override {
                viAlias = true;
                vimAlias = true;
              })
              pkgs.ninja
              pkgs.nixfmt-rfc-style
              pkgs.ollama
              pkgs.opam
              pkgs.pam-reattach
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
              "ghcup"
              "libtool"
              "openjdk@17"
              "pkg-config"
            ];
            casks = [
              "1password"
              "flutter"
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
          nix.settings.experimental-features = "nix-command flakes";
          nixpkgs = {
            hostPlatform = "aarch64-darwin";
            config.allowUnfree = true;
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
                echo "setting up /Applications..." >&2
                dir=/Applications/Nix\ Apps
                rm -rf "$dir"
                mkdir -p "$dir"
                find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
                while read -r src; do
                  # Syncs the app as a trampoline
                  app_name=$(basename -s ".app" "$src")
                  echo "syncing $app_name" >&2
                  ${pkgs.rsync}/bin/rsync --archive --checksum --chmod=-w --copy-unsafe-links --delete "$src/" "$dir/$app_name.app"

                  # Replaces icons if replacement exist
                  icns_src="${paths.config}/icons/$app_name.icns"
                  if [ -f "$icns_src" ]; then
                    icns_tgt=$(find "$dir/$app_name.app/Contents/Resources" -name "*.icns")
                    cp "$icns_src" "$icns_tgt"
                  fi
                done
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
                  "/Applications/Nix Apps/Google Chrome.app"
                  "/System/Applications/Mail.app"
                  "/System/Applications/Calendar.app"
                  "/Applications/Todoist.app"
                  "/Applications/Nix Apps/Spotify.app"
                  "/Applications/Ghostty.app"
                  "/Applications/Nix Apps/Visual Studio Code.app"
                  "/Applications/Nix Apps/Slack.app"
                  "/Applications/KakaoTalk.app"
                  "/Applications/WhatsApp.app"
                  "/Applications/Messenger.app"
                  "/System/Applications/System Settings.app"
                ];
                show-recents = false;
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
            stateVersion = 5;
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
