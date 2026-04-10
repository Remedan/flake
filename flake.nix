{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
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
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      extraPkgs = final: prev: {
        rc2nix = inputs.plasma-manager.packages.${system}.rc2nix;
        claude-desktop = inputs.claude-desktop.packages.${system}.claude-desktop;
      };
      # Overlay for packages that are broken in unstable
      stablePkgs = final: prev: {
        ifm = inputs.nixpkgs-stable.legacyPackages.${system}.ifm;
      };
      overlays = [
        inputs.nix-vscode-extensions.overlays.default
        extraPkgs
        stablePkgs
      ];
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = overlays ++ [ inputs.nixgl.overlay ];
      };
      mkNixosSystem = { name, extraSystemModules ? [ ], extraHomeModules ? [ ] }: inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          { nixpkgs.overlays = overlays; }
          ./hosts/${name}/system.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.users.remedan = import ./hosts/${name}/user.nix;
            home-manager.sharedModules = import ./modules/user ++ [
              inputs.nix-flatpak.homeManagerModules.nix-flatpak
              inputs.plasma-manager.homeModules.plasma-manager
              (import ./secrets/common.nix)
            ] ++ extraHomeModules;
          }
        ] ++ import ./modules/system ++ extraSystemModules;
      };
    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;

      nixosConfigurations = {
        weatherwax = mkNixosSystem {
          name = "weatherwax";
          extraHomeModules = [ (import ./secrets/weatherwax.nix) ];
        };
        rincewind = mkNixosSystem {
          name = "rincewind";
          extraSystemModules = [ inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-yoga ];
        };
        # Testing VM
        nixos = { name = "nixos"; };
      };

      # Atuin is a Fedora-based system (standalone Home Manager)
      homeConfigurations."vojta@atuin" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          (import ./hosts/atuin/user.nix)
          (import ./secrets/common.nix)
          (import ./secrets/atuin.nix)
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
          inputs.plasma-manager.homeModules.plasma-manager
        ] ++ import ./modules/user;
      };
    };
}
