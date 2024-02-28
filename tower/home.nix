{ config, pkgs, ... }: {
  imports = [
    ./../home/tmux.nix
  ];

  home.username = "kozko";
  home.homeDirectory = "/home/kozko";
  home.stateVersion = "23.05";

  home.sessionVariables = rec {
    EDITOR = "nvim";
  };

  ## fonts
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    firefox-wayland
    keepassxc
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
    swaylock
    (pkgs.discord.override { withOpenASAR = true; withVencord = true; })
    qmk
    vale
    calibre
    k9s
    killall
    xfce.thunar
    unzip
    cura
    udiskie
    mate.engrampa
    htop
    age
    cliphist
    wl-clipboard
    hyprpaper
    pavucontrol
    obsidian
    pyprland
    nodePackages.jsonlint
    p7zip
    ns-usbloader
    fuzzel
    lazygit
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
  ## hyprland config
  home.file."${config.xdg.configHome}/hypr" = {
    source = ./../apps/hyprland;
    recursive = true;
  };
  home.file."${config.xdg.configHome}/waybar" = {
    source = ./../apps/waybar;
    recursive = true;
  };
  home.file."${config.xdg.configHome}/wofi" = {
    source = ./../apps/wofi;
    recursive = true;
  };

  home.file."${config.xdg.configHome}/nvim" = {
    source = ./../apps/nvim;
    recursive = true;
  };


  home.file."${config.xdg.configHome}/mako/" = {
    source = ./../apps/mako;
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

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "none";
      };
      font = {
        size = 13;
      };
      cursor = {
        style = "Beam";
      };
    };
  };


  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "command-not-found"
        "z"
        "tmux"
      ];
    };
    sessionVariables = {
      ZSH_TMUX_AUTOSTART = "true";
      ZSH_TMUX_AUTOCONNECT = "true";
      ZSH_TMUX_CONFIG = "/home/kozko/.config/tmux/tmux.conf";
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

  services.udiskie = {
    enable = true;
  };
}
