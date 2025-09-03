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
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.home-manager.follows = "home-manager";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcp-servers-nix.url = "github:natsukium/mcp-servers-nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # waybar.url = "github:Alexays/Waybar";
    # nixos-cosmic = {
    #   url = "github:lilyinstarlight/nixos-cosmic";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # raise.url = "github:knarkzel/raise";
  };

  # outputs = inputs@{ self, nixpkgs, home-manager, darwin, hyprland, waybar }: {
  outputs = {nixpkgs, home-manager, darwin, nixos-hardware, mcp-servers-nix, ...} @ inputs: {
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
      framework = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; # this is the important part
        modules = [
          ./framework/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kozko = import ./framework/home.nix;
          }
          { nixpkgs.overlays = [ (import ./home/overlays.nix) ]; }
          nixos-hardware.nixosModules.framework-13-7040-amd
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
