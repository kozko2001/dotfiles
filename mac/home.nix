
{ config, pkgs, ... }: {

  home.stateVersion = "23.05";

## fonts
  fonts.fontconfig.enable = true;
  
  home.packages = with pkgs; [
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
      syncthing
      neovim      
      jq
      ripgrep
      pre-commit
  ];

  programs.home-manager.enable = true;


  programs.git = {
    enable = true;
    userName = "Jordi Coscolla";
    userEmail = "jordi@coscolla.net";
    ignores = [
      "target"
      ".vscode"
      ".direnv"
      "*~"
      "*.swp"
    ];
  };
  
  services.syncthing = {
    enable = true;
    # user = "kozko";
    # dataDir = "/home/kozko/syncthing";
    # configDir = "/home/kozko/syncthing/.config/syncthing";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableVteIntegration = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
          "npm"
          "docker"
          "command-not-found"
          "z"
          "history-substring-search"
          "rust"
          "cargo"
      ];
    };
  };

  programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        aws = {
          disabled = true;
        };
      };
    };
  programs.bat.enable = true;
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;


  home.file.".config/nvim" = {
    source = ./../apps/nvim;
    recursive = true;
  };

  home.file.".hammerspoon/" = {
    source = ./../apps/hammerspoon;
    recursive = true;
  };


  programs.firefox.profiles =
    let settings = {
        "browser.ctrlTab.recentlyUsedOrder" = false;
        "browser.uidensity" = 1;
        "browser.urlbar.update1" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.socialtracking.annotate.enabled" = true;
        "services.sync.declinedEngines" = "addons,prefs";
        "services.sync.engine.addons" = false;
        "services.sync.engineStatusChanged.addons" = true;
        "services.sync.engine.prefs" = false;
        "services.sync.engineStatusChanged.prefs" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "gfx.webrender.all" = true;
        "general.smoothScroll" = true;
      };
    in
    {
      home = {
        id = 0;
        inherit settings;
      };
    };
}
