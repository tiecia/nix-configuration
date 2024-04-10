{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    kalc.enable = lib.mkEnableOption "Enable kalc";
  };

  config = mkIf config.kalc.enable {
    home.packages = with pkgs; [
      libsForQt5.kcalc
    ];
  };
}
