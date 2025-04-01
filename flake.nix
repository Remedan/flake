{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, nix-flatpak, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;

      nixosConfigurations.weatherwax = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/weatherwax/system.nix
        ] ++ import ./modules/system;
      };
      homeConfigurations."remedan@weatherwax" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          (import ./hosts/weatherwax/user.nix)
          (import ./secrets/common.nix)
          (import ./secrets/weatherwax-user.nix)
          nix-flatpak.homeManagerModules.nix-flatpak
        ] ++ import ./modules/user;
      };

      nixosConfigurations.rincewind = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/rincewind/system.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-x1-yoga
        ] ++ import ./modules/system;
      };
      homeConfigurations."remedan@rincewind" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          (import ./hosts/rincewind/user.nix)
          (import ./secrets/common.nix)
          nix-flatpak.homeManagerModules.nix-flatpak
        ] ++ import ./modules/user;
      };

      nixosConfigurations.atuin = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/atuin/system.nix
          nixos-hardware.nixosModules.dell-latitude-5520
        ] ++ import ./modules/system;
      };
      homeConfigurations."vojta@atuin" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          (import ./hosts/atuin/user.nix)
          (import ./secrets/common.nix)
          (import ./secrets/atuin-user.nix)
          nix-flatpak.homeManagerModules.nix-flatpak
        ] ++ import ./modules/user;
      };

      # Testing VM
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/nixos/system.nix
        ] ++ import ./modules/system;
      };
      homeConfigurations."remedan@nixos" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          (import ./hosts/nixos/user.nix)
          nix-flatpak.homeManagerModules.nix-flatpak
        ] ++ import ./modules/user;
      };
    };
}
