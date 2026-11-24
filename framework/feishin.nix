{ pkgs, ... }: {
  # Feishin: desktop client for Jellyfin, Navidrome and OpenSubsonic music servers.
  home.packages = [
    pkgs.feishin
  ];
}
