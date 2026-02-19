{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nixgl.url = "github:nix-community/nixGL";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, nix-flatpak, nixgl, plasma-manager, claude-desktop, ... }:
    let
      system = "x86_64-linux";
      extraPkgs = final: prev: {
        rc2nix = plasma-manager.packages.${system}.rc2nix;
        claude-desktop = claude-desktop.packages.${system}.claude-desktop;
      };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          nixgl.overlay
          extraPkgs
        ];
      };
    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;

      nixosConfigurations.weatherwax = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          { nixpkgs.overlays = [ extraPkgs ]; }
          ./hosts/weatherwax/system.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.users.remedan = import ./hosts/weatherwax/user.nix;
            home-manager.sharedModules = import ./modules/user ++ [
              nix-flatpak.homeManagerModules.nix-flatpak
              plasma-manager.homeModules.plasma-manager
              (import ./secrets/common.nix)
              (import ./secrets/weatherwax.nix)
            ];
          }
        ] ++ import ./modules/system;
      };

      nixosConfigurations.rincewind = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          { nixpkgs.overlays = [ extraPkgs ]; }
          ./hosts/rincewind/system.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-x1-yoga
          home-manager.nixosModules.home-manager
          {
            home-manager.users.remedan = import ./hosts/rincewind/user.nix;
            home-manager.sharedModules = import ./modules/user ++ [
              nix-flatpak.homeManagerModules.nix-flatpak
              plasma-manager.homeModules.plasma-manager
              (import ./secrets/common.nix)
            ];
          }
        ] ++ import ./modules/system;
      };

      # Atuin is a Fedora-based system (standalone Home Manager)
      homeConfigurations."vojta@atuin" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          (import ./hosts/atuin/user.nix)
          (import ./secrets/common.nix)
          (import ./secrets/atuin.nix)
          nix-flatpak.homeManagerModules.nix-flatpak
          plasma-manager.homeModules.plasma-manager
        ] ++ import ./modules/user;
      };

      # Testing VM
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          { nixpkgs.overlays = [ extraPkgs ]; }
          ./hosts/nixos/system.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.users.remedan = import ./hosts/nixos/user.nix;
            home-manager.sharedModules = import ./modules/user ++ [
              nix-flatpak.homeManagerModules.nix-flatpak
              plasma-manager.homeModules.plasma-manager
            ];
          }
        ] ++ import ./modules/system;
      };
    };
}
