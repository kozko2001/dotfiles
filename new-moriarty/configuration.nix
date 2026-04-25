{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "new-moriarty";
    nameservers = [ "8.8.8.8" ];
    defaultGateway = "192.168.1.1";
    useDHCP = false;
    interfaces = {
      enp0s31f6= {
        useDHCP = false;
        ipv4.addresses = [{
          address = "192.168.1.245";
          prefixLength = 24;
        }];
      };
    };
    firewall = {
      enable = true;
      # k3s required ports
      allowedTCPPorts = [ 22 6443 10250 ];
      allowedUDPPorts = [ 8472 51820 ];
    };
  };

  time.timeZone = "Europe/Madrid";

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

  users.users.kozko = {
    isNormalUser = true;
    description = "kozko";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDbP8q6UqeDNa36mnG0NfZMRks0W4N1ZxNLkDVwkw2NTJQBbwmlsEo0DZ2L13E2eiIT6dEi0f0rfDH4oYgp/z/PUg3uUp+jbS33zTcdseyxX5TapDKNxEuGL9f5rqQrsQL4snZaMAq+URy9kOIZ0oO5Br00jfdio1UWegMkIe49EAGTID5wmKgat/6ISyCzyK1fEMHETNqIEkF6Rzmw7NIB9/1hBwEP7++9X2eyILmTfUkbr5GldQJCYLH3cIT1hNqA7didwhSKeK8mLKFKuWDZG5Tw12QJsMg5mtM4ms+78WJs+kTHnZXazHlUhv1suz0ibt5bVaz1wyHw9bcjsnJoCdqvAnvrrNyKwnyH6nqfi7sGSK4sdAxZJVbwUQppAORSbrSTG7EGZVcy8Uk4qnfgm+u/uOF5oy5w5nf6Z7IBV0myVgemokvCaRn1dFlO82ZP2OpWMAWULLCN28Y8bHrWc/U1zRX3wQvHlcbHT9woFK37OkwMm6dNOvr45PNheik20Zsm0Fl1FNlUEbewrlPPJCGj+t1XQlaSUDbWzcTkUxtB6BwsKcRfy/hcRGc5oMnCUVWrkLBT/awE2zpsDX1INKaJOxt8yH+fUTdvZSkW5UaBfGcnyDBI43Jee5UTU61PgOhD8CSYYIJ1RsYU0Q0IwdVO1vXIRcZaUC6aj/gbZw== kozko@MacBook-Pro-de-Jordi.local"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      trusted-users = [ "root" "kozko" ];
    };
  };

  # NFS client kernel modules (required for kubelet to mount NFS PVCs)
  # rbd module required for Rook-Ceph RBD block device PVCs
  boot.kernelModules = [ "nfs" "nfsv4" "rbd" "ceph" ];

  # RPC bind daemon — required by the NFS client stack
  services.rpcbind.enable = true;


  environment.systemPackages = with pkgs; [
    neovim
    git
    htop
    curl
    wget
    kubectl
    k9s
    nfs-utils
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  programs.zsh.enable = true;
  virtualisation.docker.enable = true;

  # k3s agent — joins the existing HA cluster.
  # The agent has a built-in embedded load balancer: after the first successful
  # connection it caches all server addresses (192.168.1.246, .247, .38) and
  # handles failover automatically. The serverAddr is only the bootstrap entry point.
  # If that server is down at boot, systemd will keep restarting until one is reachable.
  #
  # Before deploying, copy the node token to /etc/k3s-token on this machine:
  #   scp root@192.168.1.246:/var/lib/rancher/k3s/server/node-token kozko@192.168.1.245:/tmp/k3s-token
  #   sudo mv /tmp/k3s-token /etc/k3s-token && sudo chmod 600 /etc/k3s-token
  services.k3s = {
    enable = true;
    role = "agent";
    serverAddr = "https://192.168.1.246:6443";
    tokenFile = "/etc/k3s-token";
  };

  system.stateVersion = "24.11";
}
