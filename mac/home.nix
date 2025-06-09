{ config, pkgs, ... }: {

  imports = [
    ./../home/tmux.nix
    ./../home/alacritty.nix
  ];
  home.stateVersion = "23.05";

  ## fonts
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    syncthing
    neovim
    jq
    ripgrep
    pre-commit
    vale
    tmux
    ripgrep
    age
    sox
    htop
    lazygit
    typescript-language-server
    k9s
    kubectx
  ];

  programs.home-manager.enable = true;

  home.sessionVariables = rec {
    EDITOR = "nvim";
  };

  programs.git = {
    enable = true;
    userName = "Jordi Coscolla";
    userEmail = "jordi.coscolla@proton.ch";
    lfs.enable = true;
    includes = [
      {
        condition = "gitdir:~/tmp/";
        contents = {
          user = {
            email = "kozko2001@gmail.com";
          };
          core = {
            sshCommand = "ssh -i ~/.ssh/id_rsa";
          };
        };
      }
    ];
    extraConfig = {
      push = { autoSetupRemote = true; };
    };
    ignores = [
      "target"
      ".vscode"
      ".direnv"
      "*~"
      "*.swp"
      "shell.nix"
      "http-client.env.json"
      "*.aider*"
    ];
  };

  programs.git.difftastic.enable = true;
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
    initContent = ''
      alias fkill='ps -ef | sed 1d | tac | fzf -m | awk "{print \$2}" | xargs kill -9'
      nvm() {
        unset -f nvm node npm npx yarn
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        nvm "$@"
      }

      node() {
        unset -f nvm node npm npx yarn
        
        # Load NVM
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
        
        # Now call the actual node command
        node "$@"
      }

      npm() {
        unset -f nvm node npm npx yarn
        
        # Load NVM
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
        
        # Now call the actual npm command
        npm "$@"
      }

      npx() {
        unset -f nvm node npm npx yarn
        
        # Load NVM
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
        
        # Now call the actual npx command
        npx "$@"
      }

      yarn() {
        unset -f nvm node npm npx yarn
        
        # Load NVM
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
        
        # Now call the actual yarn command
        yarn "$@"
      }
      export NVM_DIR="$HOME/.nvm"
      export PATH="$PATH;/Applications/IntelliJ IDEA.app/Contents/MacOS"

      export PYENV_ROOT="$HOME/.pyenv"
      [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init -)"
      eval "$(zoxide init zsh)"
    '';
    oh-my-zsh = {
      enable = true;
      theme = "terminalparty";
      plugins = [
        "git"
        "history-substring-search"
        "tmux"
        "docker-compose"
      ];
    };

    sessionVariables = {
      ZSH_TMUX_AUTOSTART = "true";
      ZSH_TMUX_AUTOCONNECT = "true";
      ZSH_TMUX_CONFIG = "/Users/jordi/.config/tmux/tmux.conf";

      NIX_AUTO_RUN = "true";
      OLLAMA_API_BASE = "http://127.0.0.1:11434";
      OLLAMA_CONTEXT_LENGTH = "8192";
    };

  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = { };
  };
  programs.bat.enable = true;
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;

  home.file."${config.xdg.configHome}/tridactyl" = {
    source = ./../apps/tridactyl;
    recursive = true;
  };


  home.file.".config/nvim" = {
    source = ./../apps/nvim;
    recursive = true;
  };

  home.file.".hammerspoon/" = {
    source = ./../apps/hammerspoon;
    recursive = true;
  };


  home.file.".config/kitty/" = {
    source = ./../apps/kitty;
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
