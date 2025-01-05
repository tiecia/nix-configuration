{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
in {
  imports = [
    ./dotnet-maui.nix
  ];

  options = {
    dotnet = {
      enable = lib.mkEnableOption "dotnet";
      maui = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          example = false;
          description = "Allows the .NET Maui workload to be installed with dotnet cli";
        };
      };
    };
  };

  config = let
    maui = config.dotnet.maui.enable;
  in
    lib.mkIf config.dotnet.enable {
      home.packages = [
        pkgs.jetbrains.rider
        # (lib.mkIf (!maui) pkgs.dotnet-sdk_8)
      ];
    };
}
