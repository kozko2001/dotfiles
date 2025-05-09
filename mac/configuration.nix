{ config, pkgs, inputs,... }:

{
  environment.shells = with pkgs; [ zsh ];
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    [
      neovim
      syncthing
      gcc
      nixd
      alejandra
      typescript-language-server
      localsend
    ];

  ids.gids.nixbld = 350;
  security.pam.services.sudo_local.touchIdAuth = true;
  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  homebrew = {
    enable = true;
    onActivation.upgrade = false;
    onActivation.autoUpdate = false;
    # upates homebrew packages on activation,
    # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
    brews = [ "python3" "pyenv" "docker-compose" "awscli" "pre-commit" "pyright" "ollama"];
    casks = [
      "hammerspoon"
      "obsidian"
      "zoom"
      "kitty"
      "firefox"
      "orbstack"
      "cursor"
      "keepassxc"
      "dbeaver-community"
      "pgadmin4"
      "phpstorm"
      "spotify"
      "sublime-text"
      "zen-browser"
    ];
  };

  users.users.jordi.home = "/Users/jordi/";

  # Add ability to used TouchID for sudo authentication

  networking.dns = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];


  system.defaults = {
    dock = {
      autohide = true;
      showhidden = true;
      mineffect = "scale";
      launchanim = false;
      show-process-indicators = true;
      tilesize = 48;
      static-only = true;
      mru-spaces = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
    };
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
    NSGlobalDomain = {
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 10;
      KeyRepeat = 1;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
    };
  };
  environment.etc."sudoers.d/timeout".text = ''
    Defaults timestamp_timeout=90
  '';
}
