{ pkgs, config, lib, ... }: {
  home.packages = with pkgs; [
    herdr
  ];

  # herdr rewrites its config (onboarding, settings), so it must be a real file,
  # not a symlink into the read-only nix store. Seed it from apps/herdr/config.toml
  # only when it doesn't exist yet; after that, edit ~/.config/herdr/config.toml
  # directly (or delete it and rebuild to re-seed from the repo).
  home.activation.herdrConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    dest="${config.xdg.configHome}/herdr/config.toml"
    run mkdir -p "$(dirname "$dest")"
    if [ -L "$dest" ]; then
      run rm -f "$dest"
    fi
    if [ ! -e "$dest" ]; then
      run install -m 0644 ${./../apps/herdr/config.toml} "$dest"
    fi
  '';
}
