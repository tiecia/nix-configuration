{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    platformio.enable = mkEnableOption "Enable platformio";
  };

  config = mkIf config.platformio.enable {
    home.packages = with pkgs; [
      platformio
    ];
  };
}
