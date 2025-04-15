{ config, pkgs, lib, ... }: {
  imports = [
    ./../home/tmux.nix
    ./../home/alacritty.nix
  ];
  home.username = "kozko";
  home.homeDirectory = "/home/kozko";

  home.stateVersion = "24.11";
  home.sessionVariables = rec {
    EDITOR = "nvim";
  };
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    syncthing
    jq
    ripgrep
    k9s
    killall
    xfce.thunar
    unzip
    udiskie
    ns-usbloader
    age
    htop
    lazygit
    kubectl
    typescript-language-server
    lua-language-server
    feh
    code-cursor
    gnumake
    gcc
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

  programs.git.difftastic.enable = true;
  home.file."${config.xdg.configHome}/nvim" = {
    source = ./../apps/nvim;
    recursive = true;
  };
  services.syncthing = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
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

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    initExtra = ''
      eval "$(zoxide init zsh)"
      '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "tmux"
      ];
    };
    sessionVariables = {
      ZSH_TMUX_AUTOSTART = "true";
      ZSH_TMUX_AUTOCONNECT = "true";
      ZSH_TMUX_CONFIG = "/home/kozko/.config/tmux/tmux.conf";
    };

  };


}
