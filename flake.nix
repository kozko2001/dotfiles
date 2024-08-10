{
  description = "kzk configuration";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # hyprland.inputs.nixpkgs.follows = "nixpkgs-unstable";
# # hypridle.url = "github:hyprwm/hypridle";
# # hypridle.inputs.nixpkgs.follows = "nixpkgs-unstable";
    waybar.url = "github:Alexays/Waybar";
#     waybar.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  # outputs = inputs@{ self, nixpkgs, home-manager, darwin, hyprland, waybar }: {
  outputs = {nixpkgs, home-manager, darwin, ...} @ inputs: {
    nixosConfigurations = {
      tower = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./tower/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kozko = import ./tower/home.nix;
          }
          { nixpkgs.overlays = [ (import ./home/overlays.nix) ]; }
        ];
      };
      mate = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; # this is the important part
        modules = [
          ./mate/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kozko = import ./mate/home.nix;
          }
          { nixpkgs.overlays = [ (import ./home/overlays.nix) ]; }
        ];
      };
    };
    darwinConfigurations = {
      mac = darwin.lib.darwinSystem {
        # system = "aarch64-darwin";
        system = "aarch64-darwin";
        modules = [
          ./mac/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jordi = import ./mac/home.nix;
          }
        ];
      };
    };
  };
}
