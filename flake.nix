{
  description = "Nixos config flake";

  inputs = {
    spicetify-nix.url = "github:the-argus/spicetify-nix";

    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-master,
    spicetify-nix,
    nixos-hardware,
    plasma-manager,
    hyprland,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    pkgs-master = import nixpkgs-master {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };

    specialArgsDesktop = {inherit inputs system pkgs pkgs-master spicetify-nix plasma-manager;};
    specialArgsCli = {inherit inputs system pkgs pkgs-master;};
  in {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgsDesktop;

        modules = [
          ./hosts/desktop/configuration.nix
        ];
      };

      l390 = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgsDesktop;

        modules = [
          ./hosts/l390/configuration.nix
        ];
      };

      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgsCli;

        modules = [
          ./hosts/wsl/configuration.nix
        ];
      };

      surfacebook = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgsDesktop;

        modules = [
          ./hosts/surfacebook/configuration.nix
        ];
      };

      sls = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgsDesktop;

        modules = [
          ./hosts/sls/configuration.nix
          nixos-hardware.nixosModules.microsoft-surface-common
        ];
      };
    };
  };
}
