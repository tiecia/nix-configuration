{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    logitech.enable = lib.mkEnableOption "Enable logitech support";
  };

  config = mkIf config.logitech.enable {
    hardware.logitech.wireless.enable = true;
    hardware.logitech.wireless.enableGraphical = true; # for solaar to be included
  };
}
