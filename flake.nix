{
  description = "Nixos config flake";

  inputs = {
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-dotnet.url = "github:nixos/nixpkgs?rev=a30e284fcd69aadaec15c563b1649667fc77cd4d";

    nixos-hardware.url = "github:nixos/nixos-hardware?rev=d23a3bc3c600a064c72c7fb02862edfab11a46cf";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cli.url = "github:water-sucks/nixos";

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

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-display-tools.url = "github:tiecia/hyprland-display-tools";

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # test-service = {
    #   url = "path:./services/test/";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

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
    nixpkgs-dotnet,
    nixos-hardware,
    nixos-wsl,
    home-manager,
    stylix,
    winapps,
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
      };
      overlays = [
        (final: prev: {
          inherit (pkgs-master) zsync;
          inherit (pkgs-stable) ceph;
        })
      ];
    };
    pkgs-dotnet = import nixpkgs-dotnet {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };

    winapps-pkgs = winapps.packages.${system};

    globalConfig = {
      terminal = "alacritty";
    };

    specialArgsDesktop = {inherit inputs system pkgs pkgs-master pkgs-stable pkgs-dotnet globalConfig winapps-pkgs;};
    specialArgsCli = {inherit inputs system pkgs pkgs-master pkgs-stable pkgs-dotnet globalConfig;};

    sharedModules = [
      inputs.nixos-cli.nixosModules.nixos-cli
    ];
  in {
    homeConfigurations = {
      "tiec@TyLaptopStudioNix" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = specialArgsDesktop;

        modules = [
          ./hosts/TyLaptopStudioNix/home.nix
        ];
      };

      "tiec@TyDesktopNix" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = specialArgsDesktop;

        modules = [
          ./hosts/TyDesktopNix/home.nix
        ];
      };

      "tiec@fw16" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = specialArgsDesktop;

        modules = [
          ./hosts/fw16/home.nix
        ];
      };

      "tiec@server" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = specialArgsDesktop;

        modules = [
          ./hosts/server/home.nix
        ];
      };
    };

    nixosConfigurations = {
      TyDesktopNix = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgsDesktop;

        modules =
          [
            ./hosts/TyDesktopNix/configuration.nix
          ]
          ++ sharedModules;
      };

      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgsCli;

        modules =
          [
            ./hosts/wsl/configuration.nix
            nixos-wsl.nixosModules.default
          ]
          ++ sharedModules;
      };

      TyLaptopStudioNix = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgsDesktop;

        modules =
          [
            ./hosts/TyLaptopStudioNix/configuration.nix
            nixos-hardware.nixosModules.microsoft-surface-common
          ]
          ++ sharedModules;
      };

      fw16 = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgsDesktop;

        modules =
          [
            ./hosts/fw16/configuration.nix
          ]
          ++ sharedModules;
      };

      server = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgsCli;

        modules =
          [
            ./hosts/server/configuration.nix
          ]
          ++ sharedModules;
      };
    };
  };
}
