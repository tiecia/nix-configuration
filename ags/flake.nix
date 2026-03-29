{
  description = "AGS v3 development shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ags,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    agsPkgs = ags.packages.${system};
    agsWithDeps = agsPkgs.default.override {
      extraPackages = [
        agsPkgs.io
        agsPkgs.astal3
        agsPkgs.apps
        agsPkgs.auth
        agsPkgs.battery
        agsPkgs.bluetooth
        agsPkgs.greet
        agsPkgs.hyprland
        agsPkgs.mpris
        agsPkgs.network
        agsPkgs.notifd
        agsPkgs.powerprofiles
        agsPkgs.tray
        agsPkgs.wireplumber
      ];
    };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = [
        agsWithDeps

        pkgs.bun
        pkgs.esbuild
        pkgs.dart-sass
        pkgs.nodejs
        pkgs.typescript
      ];

      shellHook = ''
        echo "AGS dev shell ready"
        ags --version || true
      '';
    };
  };
}
