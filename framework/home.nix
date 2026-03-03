{ config, pkgs, lib, ... }: {
  imports = [
    ./../home/tmux.nix
    ./../home/alacritty.nix
    ./niri-home.nix
  ];

  custom.niri.enable = true;

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
    # ns-usbloader  # Temporarily disabled - broken in current nixpkgs
    age
    htop
    lazygit
    kubectl
    feh
    code-cursor
    gnumake
    gcc
    heroic
    unrar
    stylua
    typescript-language-server
    lua-language-server
    marksman
    # Python
    uv
    pyright
    ruff
    python314
    # Node.js
    nodejs
    pnpm
    vscode-langservers-extracted
    biome
    tridactyl-native
    vial
    claude-code
    opencode
    qbittorrent
    keepmenu
    calibre
    joplin-desktop
  ];

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Jordi Coscolla";
        email = "jordi@coscolla.net";
      };
    };
    ignores = [
      "target"
        ".vscode"
        ".direnv"
        "*~"
        "*.swp"
    ];
  };

  programs.difftastic = {
    enable = true;
    git.enable = true;
  };

  home.file."${config.xdg.configHome}/tridactyl" = {
    source = ./../apps/tridactyl;
    recursive = true;
  };
  home.file."${config.xdg.configHome}/nvim" = {
    source = ./../apps/nvim;
    recursive = true;
  };
  
  home.file."${config.xdg.configHome}/keepmenu/config.ini".text = ''
    [dmenu]
    dmenu_command = rofi -dmenu -i -p "KeePass"
    
    [database]
    # Database path - you'll need to set this to your .kdbx file
    database_1 = /home/kozko/keepass/keepass.kdbx
    
    [dmenu_passphrase]
    # Optional: customize passphrase prompt
    # dmenu_command = rofi -dmenu -password -p "Passphrase"
  '';
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

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages = (epkgs: [
      # Using with-grammars to select specific grammars and avoid broken tree-sitter-razor
      (epkgs.treesit-grammars.with-grammars (grammars: with grammars; [
        tree-sitter-c
        tree-sitter-cpp
        tree-sitter-rust
        tree-sitter-python
        tree-sitter-javascript
        tree-sitter-typescript
        tree-sitter-tsx
        tree-sitter-json
        tree-sitter-yaml
        tree-sitter-toml
        tree-sitter-markdown
        tree-sitter-bash
        tree-sitter-nix
        tree-sitter-lua
        tree-sitter-go
        tree-sitter-html
        tree-sitter-css
      ]))
    ]);
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    initContent = ''
      eval "$(zoxide init zsh)"
      alias fkill='ps -ef | sed 1d | tac | fzf -m | awk "{print \$2}" | xargs kill -9'
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
