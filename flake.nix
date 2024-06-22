{
  description = "Nixos config flake";

  inputs = {
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    # NOTE: hyprland and hyprsplit must be updated together
    # A couple of commits after v1.41.0
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=8055b1c00a102f5419e40f5eddfb6ee8be693f33";

    # v1.41.1
    hyprsplit = {
      url = "github:shezdy/hyprsplit?rev=9acac9b62eef71ff60234140229a97a232a92ef4";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };

    ags.url = "github:Aylur/ags?ref=v1.8.2";

    custom-nvim.url = "path:./nvim/";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-master,
    spicetify-nix,
    nixos-hardware,
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

    specialArgsDesktop = {inherit inputs system pkgs pkgs-master spicetify-nix hyprland;};
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
