# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "powersave";

  swapDevices = [ 
  {
    device = "/var/lib/swapfile";
    size = 16 * 1024;
  }];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=0
  '';
  #  boot.blacklistedKernelModules = [ "snd_hda_intel" "snd_soc_skl" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  services.tlp = {
    enable = true;
    extraConfig = ''
      CPU_SCALING_GOVERNOR_ON_AC=performance
      CPU_SCALING_GOVERNOR_ON_BAT=powersave
      SOUND_POWER_SAVE_ON_AC=0
      SOUND_POWER_SAVE_ON_BAT=1

# Runtime Power Management for PCI(e) bus devices: on=disable, auto=enable.
# Default: on (AC), auto (BAT)
      RUNTIME_PM_ON_AC=on
      RUNTIME_PM_ON_BAT=auto

# Battery feature drivers: 0=disable, 1=enable
# Default: 1 (all)
      NATACPI_ENABLE=1
      TPACPI_ENABLE=1
      TPSMAPI_ENABLE=1
      '';
  };

  networking.hostName = "mate-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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
  services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

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
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  #hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.enableAllFirmware = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kozko = {
    isNormalUser = true;
    description = "kozko";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
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
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  nix = {
    package = pkgs.nixFlakes;
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
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    neovim
    git
    #   sof-firmware
    rustup
    swayidle
    tailscale
    gcc
    rustup
    brightnessctl
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

  services.udisks2.enable = true;
  services.blueman.enable = true;
  programs.ns-usbloader.enable = true;
}
