{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    (pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; })
    ];
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "none";
      };
      font = {
        size = 13;
        normal.family = "Iosevka NF";
        bold.family = "Iosevka NF";
        italic.family = "Iosevka NF";
      };
      cursor = {
        style = "Beam";
      };
    };
  };

}
