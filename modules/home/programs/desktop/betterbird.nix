{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    betterbird.enable = lib.mkEnableOption "Enable betterbird";
  };

  config = mkIf config.betterbird.enable {
    home.packages = with pkgs; [
      betterbird
    ];
  };
}
