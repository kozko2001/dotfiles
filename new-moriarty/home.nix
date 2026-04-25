{ config, pkgs, lib, ... }: {
  home.username = "kozko";
  home.homeDirectory = "/home/kozko";
  home.stateVersion = "24.11";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    jq
    ripgrep
    htop
    lazygit
  ];

  programs.home-manager.enable = true;
}
