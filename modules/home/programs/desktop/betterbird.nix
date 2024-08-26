{
  config,
  lib,
  pkgs,
  pkgs-stable,
  inputs,
  ...
}:
with lib; {
  options = {
    betterbird.enable = lib.mkEnableOption "Enable betterbird";
  };

  config = mkIf config.betterbird.enable {
    home.packages = [
      pkgs-stable.betterbird
    ];
  };
}
