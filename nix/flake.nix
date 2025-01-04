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
          environment.systemPackages = [
            pkgs.fd
            pkgs.fzf
            pkgs.mkalias
            pkgs.neovim
            pkgs.nixfmt-rfc-style
            pkgs.ripgrep
            pkgs.skhd
            pkgs.slack
            pkgs.spotify
            pkgs.texliveFull
            pkgs.tmux
            pkgs.vscode
            pkgs.yabai
          ];
          fonts.packages = [
            pkgs.jetbrains-mono
          ];
          homebrew = {
            enable = true;
            casks = [
              "ghostty"
            ];
            masApps = {
              "Goodnotes 6" = 1444383602;
              "Messenger" = 1480068668;
              "SurfShark" = 1437809329;
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
                    echo "copying icon for $app_name" >&2
                    icns_tgt=$(find "$dir/$app_name.app/Contents/Resources" -name "*.icns")
                    cp "$icns_src" "$icns_tgt"
                  fi
                done
                rm -rf /Library/Caches/com.apple.iconservices.store
                find /private/var/folders/ \( -name com.apple.dock.iconcache -or -name com.apple.iconservices \) -exec rm -rf {} \;
                killall Finder
                killall Dock
              '';
            configurationRevision = self.rev or self.dirtyRev or null;
            defaults = {
              dock = {
                autohide = true;
                persistent-apps = [
                  "/Applications/Google Chrome.app"
                  "/System/Applications/Mail.app"
                  "/System/Applications/Calendar.app"
                  "/System/Applications/Reminders.app"
                  "/Applications/Nix Apps/Spotify.app"
                  "/Applications/Ghostty.app"
                  "/Applications/Nix Apps/Visual Studio Code.app"
                  "/Applications/Nix Apps/Slack.app"
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
              WindowManager.GloballyEnabled = false;
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
