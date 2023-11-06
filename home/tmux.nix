{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    lsof
    fzf
    zoxide
  ];

  programs.tmux = {
    enable = true;
  };
  home.file."${config.xdg.configHome}/tmux" = {
    source = ./../apps/tmux;
    recursive = true;
  };
}
