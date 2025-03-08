{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
in {
  options = {
    dotnet = {
      enable = lib.mkEnableOption "dotnet";
    };
  };

  config = lib.mkIf config.dotnet.enable {
    home.packages = [
      pkgs.jetbrains.rider
      # pkgs.dotnet-sdk_8
      # pkgs.dotnet-sdk_9
      # pkgs.dotnetCorePackages.sdk_8_0_1xx
      # pkgs.dotnetCorePackages.sdk_9_0_1xx

      (pkgs.dotnetCorePackages.combinePackages [
        pkgs.dotnetCorePackages.sdk_9_0
        pkgs.dotnetCorePackages.sdk_8_0
      ])

      pkgs.netcoredbg
    ];

    programs.bash = {
      shellAliases = {
        riderd = "(rider &) &> /dev/null";
      };
    };
  };
}
