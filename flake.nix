{
  description = "My system config with nix-darwin and home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      home-manager,
      mac-app-util,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.git
            pkgs.nixd
            pkgs.nixfmt-rfc-style
            pkgs.vim
          ];
          system.defaults = {
            ActivityMonitor.ShowCategory = 100;
            NSGlobalDomain = {
              AppleShowAllFiles = true;
              AppleInterfaceStyleSwitchesAutomatically = true;
              ApplePressAndHoldEnabled = false;
              AppleShowAllExtensions = true;
              AppleShowScrollBars = "WhenScrolling";
              NSAutomaticCapitalizationEnabled = false;
              NSAutomaticInlinePredictionEnabled = false;
              NSAutomaticDashSubstitutionEnabled = false;
              NSAutomaticPeriodSubstitutionEnabled = false;
              NSAutomaticQuoteSubstitutionEnabled = false;
              NSAutomaticSpellingCorrectionEnabled = false;
              NSAutomaticWindowAnimationsEnabled = false;
              NSNavPanelExpandedStateForSaveMode = true;
              NSNavPanelExpandedStateForSaveMode2 = true;
              InitialKeyRepeat = 15;
              KeyRepeat = 2;
              PMPrintingExpandedStateForPrint = true;
              PMPrintingExpandedStateForPrint2 = true;
            };
            CustomUserPreferences = {
              "NSGlobalDomain" = {
                "NSStatusItemSpacing" = 6;
                "NSStatusItemSelectionPadding" = 6;
              };
            };
            SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
            WindowManager.GloballyEnabled = false;
            menuExtraClock = {
              Show24Hour = true;
              ShowDayOfMonth = true;
              ShowDayOfWeek = true;
            };
            controlcenter = {
              AirDrop = false;
              BatteryShowPercentage = false;
              Bluetooth = false;
              Display = false;
              Sound = false;
            };
            finder = {
              _FXSortFoldersFirst = true;
              AppleShowAllExtensions = true;
              AppleShowAllFiles = true;
              FXDefaultSearchScope = "SCcf";
              FXPreferredViewStyle = "clmv";
              NewWindowTarget = "Home";
              ShowPathbar = true;
              ShowStatusBar = true;
            };
            loginwindow.GuestEnabled = false;
            trackpad = {
              ActuationStrength = 0;
              FirstClickThreshold = 0;
              SecondClickThreshold = 1;
            };
            dock = {
              autohide = true;
              autohide-delay = 0.0;
              autohide-time-modifier = 0.0;
              minimize-to-application = true;
              showhidden = true;
              show-recents = false;
              static-only = true;
              tilesize = 48;
            };
          };
          system.keyboard = {
            enableKeyMapping = true;
            remapCapsLockToControl = false;
          };
          networking = {
            computerName = "mba";
            hostName = "mba";
          };
          homebrew = {
            enable = true;
            onActivation.cleanup = "uninstall";
            taps = [
              "apple/apple"
              "asdf"
              "felixkratz/formulae"
              "nikitabobko/tap"
            ];
            brews = [
              "ansible"
              "asdf"
              "aws-vault"
              "awscli"
              "chamber"
              "cmake"
              "coreutils"
              "curl"
              "fastfetch"
              "flyctl"
              "fzf"
              "gh"
              "git"
              "go"
              "helm"
              "httpie"
              "imagemagick"
              "jq"
              "k6"
              "lazygit"
              "libpq"
              "neovim"
              "newman"
              "pipenv"
              "pipx"
              "postgresql@15"
              "postgresql@16"
              "rbenv"
              "ripgrep"
              "stern"
              "stow"
              "terraform_landscape"
              "tfenv"
              "tflint"
              "tmux"
              "tree"
              "trivy"
              "uv"
              "yq"
            ];
            casks = [
              "1Password" # Must be install in /Applications, so cannot use nixpkgs
              "alfred"
              "aws-vpn-client"
              "bartender"
              "discord"
              "docker"
              "font-dejavu-sans-mono-for-powerline"
              "font-dejavu-sans-mono-nerd-font"
              "font-hack-nerd-font"
              "font-inconsolata-for-powerline"
              "font-jetbrains-mono-nerd-font"
              "font-menlo-for-powerline"
              "font-meslo-for-powerline"
              "font-meslo-lg-nerd-font"
              "font-roboto-mono"
              "font-roboto-mono-for-powerline"
              "font-roboto-mono-nerd-font"
              "font-sf-mono-for-powerline"
              "font-sf-mono-nerd-font"
              "insomnia"
              "logi-options+"
              "ngrok"
              "spotify"
              "steam"
              "visual-studio-code"
              "visual-studio-code@insiders"
              "wezterm@nightly"
            ];
            masApps = {
              "1Password for Safari" = 1569813296;
            };
          };

          fonts.packages = with pkgs.nerd-fonts; [
            jetbrains-mono
            meslo-lg
          ];

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
          nixpkgs.config.allowBroken = true;
          # Declare the user that will be running `nix-darwin`.
          users.users.vaughan = {
            name = "vaughan";
            home = "/Users/vaughan";
          };
          security.pam.services.sudo_local.touchIdAuth = true;
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [
          ];
        };
      homeconfig =
        { pkgs, ... }:
        {
          home = {
            packages = with pkgs; [
              _1password-cli
              alacritty
              asdf-vm
              aws-vault
              cargo
              colima
              discord
              docker-buildx
              docker-client
              docker-compose
              fd
              fzf
              gh
              google-chrome
              hey
              ice-bar
              luarocks
              rectangle
              ripgrep
              stats
              tart
              wakeonlan
              watch
              wget
              windsurf
              zoom-us
            ];
            stateVersion = "25.05";
            file = {
              ".asdfrc" = {
                text = ''legacy_version_file = yes'';
                executable = false;
              };
              ".config/nvim" = {
                source = ./config/nvim;
                recursive = true;
              };
              ".hushlogin" = {
                text = ''null '';
                executable = false;
              };
            };
            shell.enableZshIntegration = true;
          };
          editorconfig = {
            enable = true;
            settings = {
              "*" = {
                charset = "utf-8";
                end_of_line = "lf";
                trim_trailing_whitespace = true;
                insert_final_newline = true;
                max_line_width = 78;
                indent_style = "space";
                indent_size = 4;
              };
            };
          };
          programs = {
            awscli.enable = true;
            bat.enable = true;
            direnv = {
              enable = true;
              enableZshIntegration = true;
            };
            eza = {
              enable = true;
              enableZshIntegration = true;
              icons = "auto";
            };
            git = {
              enable = true;
              extraConfig = {
                gpg = {
                  format = "ssh";
                  ssh = {
                    program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
                  };
                };
                commit = {
                  gpgsign = true;
                };
                init = {
                  defaultBranch = "main";
                };
              };
              diff-so-fancy = {
                enable = true;
                changeHunkIndicators = true;
                markEmptyLines = true;
              };
              signing = {
                key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMF03KsIsv7G+eLBfvodKBJVIbWY0HU/AdTH9fMpbm6/";
              };
              userEmail = "10548294+vlj91@users.noreply.github.com";
              userName = "Vaughan Jones";
            };
            home-manager.enable = true;
            lazygit.enable = true;
            neovim = {
              enable = true;
              # This is not working for some reason
              # coc.enable = true;
              defaultEditor = true;
              viAlias = true;
              vimAlias = true;
              vimdiffAlias = true;
            };
            ssh = {
              enable = true;
              extraConfig = "IdentityAgent \"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"\n";
            };
            z-lua = {
              enable = true;
              enableAliases = true;
              enableZshIntegration = true;
            };
            zsh = {
              enable = true;
              oh-my-zsh = {
                enable = true;
                plugins = [
                  # "asdf"
                  "docker"
                  "git"
                  "kubectl"
                  "terraform"
                ];
                theme = "robbyrussell";
              };
              shellAliases = {
                cat = "bat";
                lg = "lazygit";
                switch = "darwin-rebuild switch --flake ~/nixos-config";
                watch = "watch ";
              };
              autocd = true;
              dotDir = ".config/zsh";
              autosuggestion.enable = true;
              syntaxHighlighting.enable = true;
              historySubstringSearch.enable = true;
              enableCompletion = true;
              history = {
                "append" = true;
                "size" = 5000;
                "ignoreAllDups" = true;
                "ignoreSpace" = true;
                "share" = true;
              };
              sessionVariables = {
                "ASDF_GOLANG_MOD_VERSION_ENABLED" = true;
              };
            };
          };
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#mba
      darwinConfigurations."mba" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          mac-app-util.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              verbose = true;
              users.vaughan = homeconfig;
              sharedModules = [
                mac-app-util.homeManagerModules.default
              ];
            };
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              autoMigrate = true;
              user = "vaughan";
            };
          }
        ];
      };
    };
}
