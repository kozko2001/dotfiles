# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "powersave";
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=300
  '';
  services.logind.lidSwitch = "suspend-then-hibernate";
  services.logind.extraConfig = ''
    HandleLidSwitchDocked=ignore
  '';
  services.upower.enable = true;

  # boot.extraModprobeConfig = ''
  #   options snd_soc_sof_es8336 quirk=0x20
  # '';
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernel.sysctl = {
    "vm.dirty_writeback_centisecs" =  1500;
    "vm.laptop_mode" =  5;
    "vm.swappiness" = 1;
  };

#   services.tlp = {
#     enable = true;
#     extraConfig = ''
#       CPU_SCALING_GOVERNOR_ON_AC=performance
#       CPU_SCALING_GOVERNOR_ON_BAT=powersave
#       SOUND_POWER_SAVE_ON_AC=0
#       SOUND_POWER_SAVE_ON_BAT=1
#
# # Runtime Power Management for PCI(e) bus devices: on=disable, auto=enable.
# # Default: on (AC), auto (BAT)
#       RUNTIME_PM_ON_AC=on
#       RUNTIME_PM_ON_BAT=auto
#
# # Battery feature drivers: 0=disable, 1=enable
# # Default: 1 (all)
#       NATACPI_ENABLE=1
#       TPACPI_ENABLE=1
#       TPSMAPI_ENABLE=1
#       '';
#   };

  networking.hostName = "mate-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = true;
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma6.enable = true;
  # services.desktopManager.cosmic.enable = true;
  # services.displayManager.cosmic-greeter.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings.General.Experimental = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable sound with pipewire.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.enableAllFirmware = true;
  hardware.firmware = with pkgs; [sof-firmware alsa-firmware];
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = false;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kozko = {
    isNormalUser = true;
    description = "kozko";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    packages = with pkgs; [
      firefox
      #  thunderbird
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDbP8q6UqeDNa36mnG0NfZMRks0W4N1ZxNLkDVwkw2NTJQBbwmlsEo0DZ2L13E2eiIT6dEi0f0rfDH4oYgp/z/PUg3uUp+jbS33zTcdseyxX5TapDKNxEuGL9f5rqQrsQL4snZaMAq+URy9kOIZ0oO5Br00jfdio1UWegMkIe49EAGTID5wmKgat/6ISyCzyK1fEMHETNqIEkF6Rzmw7NIB9/1hBwEP7++9X2eyILmTfUkbr5GldQJCYLH3cIT1hNqA7didwhSKeK8mLKFKuWDZG5Tw12QJsMg5mtM4ms+78WJs+kTHnZXazHlUhv1suz0ibt5bVaz1wyHw9bcjsnJoCdqvAnvrrNyKwnyH6nqfi7sGSK4sdAxZJVbwUQppAORSbrSTG7EGZVcy8Uk4qnfgm+u/uOF5oy5w5nf6Z7IBV0myVgemokvCaRn1dFlO82ZP2OpWMAWULLCN28Y8bHrWc/U1zRX3wQvHlcbHT9woFK37OkwMm6dNOvr45PNheik20Zsm0Fl1FNlUEbewrlPPJCGj+t1XQlaSUDbWzcTkUxtB6BwsKcRfy/hcRGc5oMnCUVWrkLBT/awE2zpsDX1INKaJOxt8yH+fUTdvZSkW5UaBfGcnyDBI43Jee5UTU61PgOhD8CSYYIJ1RsYU0Q0IwdVO1vXIRcZaUC6aj/gbZw== kozko@MacBook-Pro-de-Jordi.local"
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "kozko";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
       xdg-desktop-portal-gtk
      ];
    };
  };

  programs.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    neovim
    git
    sof-firmware
    rustup
    swayidle
    tailscale
    gcc
    rustup
    brightnessctl
    alsa-utils
    fusee-nano

    inputs.zen-browser.packages."${system}".default

    # inputs.raise
    docker-compose

    nodejs_23
    nodePackages.pnpm

    (heroic.override {
     extraPkgs = pkgs: [
     pkgs.gamescope
     ];
     })
  ];
  environment.sessionVariables = rec {
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;


  services.openssh =
    {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";

      };
    };

  # networking.firewall.allowedTCPPorts = [ 22 ];
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  programs.zsh.enable = true;

  services.tailscale.enable = true;
  virtualisation.docker.enable = true;

  ## virt-manager https://nixos.wiki/wiki/Virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  services.udisks2.enable = true;
  services.blueman.enable = true;
  programs.ns-usbloader.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamescope.enable = true;
  programs.gamemode.enable = true;
  systemd.services.huawei-sound-fix = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "Enable sound output at startup";
    path = [ pkgs.alsa-utils ];
    serviceConfig = {
      Type = "simple";
      User = "root";
    };
  };
  systemd.user.services.kzkaudio= {
    description = "configure audio correctly";
    serviceConfig.PassEnvironment = "DISPLAY";
    script = builtins.readFile ../apps/audio.sh;
    wantedBy = [ "default.target" ]; # starts after login
  };

}
