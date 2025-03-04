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
      pkgs.dotnet-sdk_9
    ];

    programs.bash = {
      shellAliases = {
        riderd = "(rider &) &> /dev/null";
      };
    };
  };
}
