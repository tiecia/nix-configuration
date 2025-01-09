{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    mqttx.enable = lib.mkEnableOption "Enable mqttx";
  };

  config = mkIf config.mqttx.enable {
    home.packages = with pkgs; [
      mqttx
    ];
  };
}
