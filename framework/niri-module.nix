{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.niri;
in {
  options.custom.niri = {
    enable = mkEnableOption "Enable niri scrolling window manager with custom rice";
    
    wallpaper = mkOption {
      type = types.str;
      default = "https://4kwallpapers.com/images/walls/thumbs_3t/15623.jpg";
      description = "Wallpaper URL or path for background";
    };
    
    idleTimeout = mkOption {
      type = types.int;
      default = 300;
      description = "Idle timeout in seconds before screen locks";
    };
    
    dpmsTimeout = mkOption {
      type = types.int;
      default = 600;
      description = "DPMS timeout in seconds before screen turns off";
    };
  };

  config = mkIf cfg.enable {
    # Enable required services
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
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
    services.pipewire.enable = true;
    hardware.graphics.enable = true;
    security.polkit.enable = true;
    
    # Network and bluetooth
    networking.networkmanager.enable = true;
    services.blueman.enable = true;
    hardware.bluetooth.enable = true;
    
    # Power management and idle
    services.upower.enable = true;
    
    # Required packages for the rice
    environment.systemPackages = with pkgs; [
      # Core niri ecosystem
      niri
      waybar
      swaylock-effects
      swayidle
      wlogout
      
      # Background and theming
      swaybg
      wpaperd
      
      # Utilities
      rofi-wayland
      wl-clipboard
      grim
      slurp
      mako
      blueman
      networkmanagerapplet
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

    # PAM configuration for swaylock
    security.pam.services.swaylock = {};
  };
}
