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
  };

  outputs = inputs@{ self, nixpkgs, home-manager, darwin }: {
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
