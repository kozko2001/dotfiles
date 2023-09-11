{ config, pkgs, ... }: {
  home.username = "kozko";
  home.homeDirectory = "/home/kozko";
  home.stateVersion = "23.05";

## fonts
  fonts.fontconfig.enable = true;
  
  home.packages = with pkgs; [
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
      firefox-wayland
      wezterm
      kitty
      keepassxc
      logseq
      syncthing
      neovim      
      logseq
      hyprland
      wofi
      waybar
      mako
      vscodium
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
  
  ## hyprland config
  home.file."${config.xdg.configHome}/hypr" = {
    source = ./../apps/hyprland;
    recursive = true;
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
}
