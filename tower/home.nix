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
      calibre
      code-cursor
      claude-code
 (python3.withPackages (ps: [ 
      ps.pip
      ps.llm
      ps.anthropic  # needed for claude plugin
      (ps.buildPythonPackage rec {
        pname = "llm-claude-3";
        version = "0.10";
        pyproject = true;

        src = fetchFromGitHub {
          owner = "simonw";
          repo = "llm-claude-3";
          rev = version;

          hash = "sha256-3WQufuWlntywgVQUJeQoA3xXtCOIgbG+t4vnKRU0xPA=";
        };

        propagatedBuildInputs = [
          ps.anthropic
          ps.llm
        ];

        doCheck = false;

        nativeBuildInputs = [
          ps.setuptools
          ps.wheel
        ];

        dependencies = [ ps.anthropic ];

        dontCheckRuntimeDeps = true;
      })
    ]))
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
                            }
