{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    lm_sensors.enable = mkEnableOption "Enable lm_sensors";
  };

  config = mkIf config.lm_sensors.enable {
    home.packages = with pkgs; [
      lm_sensors
    ];
  };
}
