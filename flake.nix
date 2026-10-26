{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };
    herdr = {
      url = "github:ogulcancelik/herdr";
    };
  };

  outputs = { nix-darwin, home-manager, nixpkgs, nix-homebrew, herdr, ... }:
    let
      host = import ./hosts/lcyou-mac-air-m1.nix;
    in {
      darwinConfigurations.${host.hostname} = nix-darwin.lib.darwinSystem {
        inherit (host) system;
        specialArgs = { inherit host; };
        modules = [
          ./nix/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${host.user} = import ./nix/home;
            home-manager.extraSpecialArgs = { inherit host herdr; };
          }
          nix-homebrew.darwinModules.nix-homebrew
          ./nix/homebrew
        ];
      };
    };
}
