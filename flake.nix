{
  description = "Nixos config flake";

  inputs = {
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    # Updated 8/21/2024
    nixos-hardware.url = "github:nixos/nixos-hardware?rev=e8a2f6d5513fe7b7d15701b2d05404ffdc3b6dda";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cli.url = "github:water-sucks/nixos";

    # NOTE: hyprland and hyprsplit should be updated together
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=0b29caf9ab86518ff474eed5e7d19c12f96ebbd0";

    hyprsplit = {
      url = "github:shezdy/hyprsplit?rev=73452b8a1deb5c260373f68ba1daba3a426da380";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };

    hyprdock = {
      url = "github:DashieTM/hyprdock?rev=8d07dbdf446e6b21528cc994547cc8f173a70330";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprsession = {
      url = "github:tiecia/hyprsession";
    };

    matcha.url = "github:tiecia/matcha";

    ags.url = "github:Aylur/ags?ref=v1.8.2";

    stylix.url = "github:danth/stylix";

    custom-nvim.url = "path:./nvim/";

    private = {
      url = "path:/home/tiec/private/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-master,
    nixpkgs-stable,
    nixos-hardware,
    hyprland,
    stylix,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs-master = import nixpkgs-master {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "betterbird-115.9.0"
        ];
      };
      # overlays = [
      #   (final: prev: {
      #     inherit (pkgs-master) hyprpaper xdg-desktop-portal-hyprland;
      #   })
      # ];
    };

    specialArgsDesktop = {inherit inputs system pkgs pkgs-master pkgs-stable hyprland;};
    specialArgsCli = {inherit inputs system pkgs pkgs-master pkgs-stable;};

    sharedModules = [
      inputs.nixos-cli.nixosModules.nixos-cli
    ];
  in {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgsDesktop;

        modules =
          [
            stylix.nixosModules.stylix
            ./hosts/desktop/configuration.nix
          ]
          ++ sharedModules;
      };

      l390 = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgsDesktop;

        modules =
          [
            ./hosts/l390/configuration.nix
          ]
          ++ sharedModules;
      };

      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgsCli;

        modules =
          [
            ./hosts/wsl/configuration.nix
          ]
          ++ sharedModules;
      };

      surfacebook = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgsDesktop;

        modules =
          [
            ./hosts/surfacebook/configuration.nix
          ]
          ++ sharedModules;
      };

      sls = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgsDesktop;

        modules =
          [
            stylix.nixosModules.stylix
            ./hosts/sls/configuration.nix
            nixos-hardware.nixosModules.microsoft-surface-common
          ]
          ++ sharedModules;
      };
    };
  };
}
