{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    pkgs.nerd-fonts.fira-code
    ];
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "none";
      };
      font = {
        size = 13;
        normal.family = "FiraCode Nerd Font Propo";
        normal.style = "Regular";
        bold.family = "FiraCode Nerd Font Propo";
        bold.style = "Bold";
        italic.family = "FiraCode Nerd Font Propo";
      };
      cursor = {
        style = "Beam";
      };
    };
  };

}
