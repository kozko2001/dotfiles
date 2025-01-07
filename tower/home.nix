{ config, pkgs, lib, ... }: {
  imports = [
    ./../home/tmux.nix
      ./../home/alacritty.nix
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
    firefox-wayland
      keepassxc
      syncthing
      neovim
      logseq
      wofi
      waybar
      mako
      jq
      ripgrep
      pre-commit
      swaylock
      qmk
      vale
      k9s
      killall
      xfce.thunar
      unzip
# cura
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
      floorp
      heroic
# (pkgs.ollama.override
#   { acceleration = "cuda"; })
      kubectl
      typescript-language-server
      feh
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

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    initExtra = ''
      eval "$(zoxide init zsh)"
      '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
          "command-not-found"
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
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
    };
    "org/gnome/shell/extensions/paperwm" = {
      show-window-position-bar = false;
      show-workspace-indicator = false;
      gesture-workspace-fingers = 4;
      window-gap = 10;
      default-focus-mode = 1;
      show-focus-mode-icon = true;
    };

    "org/gnome/shell/extensions/paperwm/keybindings" = {
      close-window = ["<Super>q"];
      move-down = ["<Shift><Super>j"];
      move-left = ["<Shift><Super>h"];
      move-right = ["<Shift><Super>l"];
      move-up = ["<Shift><Super>k"];
      new-window = [""];
      switch-down = ["<Super>j"];
      switch-left = ["<Super>h"];
      switch-right = ["<Super>l"];
      switch-up = ["<Super>k"];

      slurp-in = [ "<Super>i" ];
      barf-out = [ "<Super>o" ];
        move-to-workspace-1 = ["<Shift><Super>1"];
        move-to-workspace-2 = ["<Shift><Super>2"];
        move-to-workspace-3 = ["<Shift><Super>3"];
        move-to-workspace-4 = ["<Shift><Super>4"];
        switch-to-workspace-1 = ["<Super>1"];
        switch-to-workspace-2 = ["<Super>2"];
        switch-to-workspace-3 = ["<Super>3"];
        switch-to-workspace-4 = ["<Super>4"];
    };
  };
                            }
