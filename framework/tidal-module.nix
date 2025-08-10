{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    custom.tidal = {
      enable = mkEnableOption "TidalCycles live coding music setup";
      
      includeAudioTools = mkOption {
        type = types.bool;
        default = true;
        description = "Include additional audio tools like Ardour and Audacity";
      };
      
      editor = mkOption {
        type = types.enum [ "emacs" "vim" ];
        default = "emacs";
        description = "Text editor to configure for TidalCycles";
      };
    };
  };

  config = mkIf config.custom.tidal.enable {
    # Enable JACK support in PipeWire for low-latency audio
    services.pipewire.jack.enable = true;
    
    # Add user to audio groups
    users.users.kozko.extraGroups = [ "audio" "jackaudio" ];
    
    # Core TidalCycles packages
    environment.systemPackages = with pkgs; [
      # TidalCycles core
      supercollider
      tidal
      jack2
      qjackctl
      
      # Editor packages based on selection
    ] ++ (if config.custom.tidal.editor == "emacs" then [
      emacs
      emacs29-packages.tidal
      emacs29-packages.haskell-mode
      emacs29-packages.company
      emacs29-packages.use-package
    ] else [
      vim
      # Add vim TidalCycles plugins here if needed
    ]) ++ (if config.custom.tidal.includeAudioTools then [
      # Additional audio tools
      ardour
      audacity
    ] else []);
    
    # Optional: Configure real-time audio permissions
    security.pam.loginLimits = [
      { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
      { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
      { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
      { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
    ];
  };
}