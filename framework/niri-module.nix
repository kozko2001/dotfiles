{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.niri;
in {
  options.custom.niri = {
    enable = mkEnableOption "Enable niri scrolling window manager with custom rice";
  };

  config = mkIf cfg.enable {
    # Enable required services
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
          user = "greeter";
        };
      };
    };

    # Disable GNOME and GDM when niri is enabled
    services.displayManager.gdm.enable = mkForce false;
    services.desktopManager.gnome.enable = mkForce false;
    services.xserver.enable = mkForce false;

    # Enable required services for niri
    programs.niri.enable = true;
    security.polkit.enable = true;
    
    # Required packages for the rice
    environment.systemPackages = with pkgs; [
      # Core niri ecosystem
      niri
      waybar
      wlogout
      
      # Background and theming
      swaybg
      wpaperd
      
      # Utilities
      rofi
      grim
      slurp
      mako
      blueman
      networkmanagerapplet
      polkit_gnome
      pavucontrol
      brightnessctl
      
      # Idle inhibition
      wayland-utils
      playerctl
      
      # Fonts for the rice
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      font-awesome
      xwayland-satellite
      
      # Cursor theme
      kdePackages.breeze

      nautilus ## need to show dialos in portal
    ];

    # Font configuration
    fonts = {
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.fira-code
        font-awesome
        roboto
      ];
      fontconfig = {
        defaultFonts = {
          serif = [ "Roboto" ];
          sansSerif = [ "Roboto" ];
          monospace = [ "JetBrainsMono Nerd Font" ];
        };
      };
    };

    # XDG portal for screen sharing and file dialogs
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };

  };
}
