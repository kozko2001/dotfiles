# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./niri-module.nix
    ];

  custom.niri.enable = true;
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "nfs" ];
  
  powerManagement.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings.General.Experimental = true;
  systemd.services.bluetooth.restartIfChanged = false;

  zramSwap.enable = true;
  zramSwap.algorithm = "zstd";

  # Required for suspend-then-hibernate to restore the RAM image from swap.
  # NOTE: swap partition must be >= RAM size or hibernate will silently fail.
  boot.resumeDevice = "/dev/disk/by-uuid/5a73add8-4982-4155-82c4-bd0fa7f38ad2";
  boot.kernelParams = [ "resume_offset=2379776" ];

  # auto-cpufreq: automatically switches governor based on AC/battery
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        energy_performance_preference = "power";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        energy_performance_preference = "performance";
        turbo = "auto";
      };
    };
  };

  # Suspend-then-hibernate on lid close (saves power if you forget)
  systemd.sleep.settings.Sleep.HibernateDelaySec = 300;
  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";
  services.logind.settings.Login.HandleLidSwitchDocked = "ignore";
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";

  services.upower.enable = true;
  services.power-profiles-daemon.enable = false;
  networking.hostName = "framework"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  networking.nftables.enable = true;

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

  services.udev = {

  packages = with pkgs; [
    qmk
    qmk-udev-rules # the only relevant
    qmk_hid
    # via
    # vial
  ]; # packages

}; # udev


  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };
  services.pulseaudio.enable = false;
  
  hardware = {
    graphics = {
        enable = true;
        enable32Bit = true;
    };
  };

  # Enable sound with pipewire.
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
    extraGroups = [ "networkmanager" "wheel" "docker" "adbusers" "kvm" "video" "render"];
    packages = with pkgs; [
#  thunderbird
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDbP8q6UqeDNa36mnG0NfZMRks0W4N1ZxNLkDVwkw2NTJQBbwmlsEo0DZ2L13E2eiIT6dEi0f0rfDH4oYgp/z/PUg3uUp+jbS33zTcdseyxX5TapDKNxEuGL9f5rqQrsQL4snZaMAq+URy9kOIZ0oO5Br00jfdio1UWegMkIe49EAGTID5wmKgat/6ISyCzyK1fEMHETNqIEkF6Rzmw7NIB9/1hBwEP7++9X2eyILmTfUkbr5GldQJCYLH3cIT1hNqA7didwhSKeK8mLKFKuWDZG5Tw12QJsMg5mtM4ms+78WJs+kTHnZXazHlUhv1suz0ibt5bVaz1wyHw9bcjsnJoCdqvAnvrrNyKwnyH6nqfi7sGSK4sdAxZJVbwUQppAORSbrSTG7EGZVcy8Uk4qnfgm+u/uOF5oy5w5nf6Z7IBV0myVgemokvCaRn1dFlO82ZP2OpWMAWULLCN28Y8bHrWc/U1zRX3wQvHlcbHT9woFK37OkwMm6dNOvr45PNheik20Zsm0Fl1FNlUEbewrlPPJCGj+t1XQlaSUDbWzcTkUxtB6BwsKcRfy/hcRGc5oMnCUVWrkLBT/awE2zpsDX1INKaJOxt8yH+fUTdvZSkW5UaBfGcnyDBI43Jee5UTU61PgOhD8CSYYIJ1RsYU0Q0IwdVO1vXIRcZaUC6aj/gbZw== kozko@MacBook-Pro-de-Jordi.local"
    ];

  };

  # Install firefox.
  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [ pkgs.tridactyl-native ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 30d --keep 5";
    flake = "/home/kozko/tmp/dotfiles";
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    hplip
    neovim
    keepassxc
    git

    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    docker-compose
    obsidian
    mangohud
    wl-clipboard ## need for neovim
    mesa
    vulkan-tools
    mesa-demos  # provides glxinfo
    proton-pass
    bindfs
    telegram-desktop
    jellyfin-mpv-shim
    localsend
    duckdb
    awscli2
    android-file-transfer  # GUI option
    jmtpfs                 # CLI/FUSE option
    gvfs
    libmtp
    pcsx2
    p7zip
    jdk
    google-chrome
    claude-code
    proton-vpn

    ## remove drm books
    python313Packages.pycryptodome
    libgourou
    luarocks
    lua5_1
    tree-sitter

    element-desktop
  ];
 
  services.openssh =
    {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";

      };
    };

  programs.zsh.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.waydroid.enable = true;
  services.udisks2.enable = true;
  services.blueman.enable = true;
  # programs.ns-usbloader.enable = true;  # Broken in current nixpkgs
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  programs.gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
        };
        gpu = {
          amd_performance = "high";
        };
      };
  };
  services.fwupd.enable = true;

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
  networking.firewall.allowedTCPPorts = [ 9090 ];  # lact GPU monitor API
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  services.tailscale.enable = true;

  fileSystems."/mnt/nas" = {
    device = "192.168.1.241:/volume1/kubernetes";
    fsType = "nfs";
    options = [ "vers=4.1" "nofail" "x-systemd.mount-timeout=10" "_netdev" ];
  };

  systemd.tmpfiles.rules = [
    "d /mnt/nas-user 0755 kozko users -"
  ];

  systemd.services.bindfs-nas = {
    description = "Bind mount NAS with user permissions";
    after = [ "mnt-nas.mount" ];
    requires = [ "mnt-nas.mount" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bindfs}/bin/bindfs -u 1000 -g 1000 /mnt/nas /mnt/nas-user";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };


  # services.envfs.enable = true; # create /bin and /usr/bin symlinks to correct store location
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  systemd.services.bluetooth-restart-on-resume = {
    description = "Restart Bluetooth adapter after system resume";
    after = [ "post-resume.target" ];
    wantedBy = [ "post-resume.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/systemctl restart bluetooth.service";
    };
  };

  nix.settings = {
    trusted-users = [ "root" "kozko" ];
    auto-optimise-store = true;
    substituters = [
      "https://cache.nixos.org"
      "https://cache.numtide.com"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCUSeBc="
    ];
  };
  services.flatpak.enable = true;
  programs.nix-ld = {
    enable = true;
    # libraries = with pkgs; [
    #   stdenv.cc.cc
    #   zlib
    #   zstd
    #   curl
    #   bzip2
    # ];
  };
  services.gvfs.enable = true;
  programs.dconf.enable = true;
}
