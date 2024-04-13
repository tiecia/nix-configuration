{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    bluetooth.enable = lib.mkEnableOption "Enable Bluetooth support";
  };

  config = mkIf config.bluetooth.enable {
    hardware.bluetooth.enable = true; # enables support for Bluetooth
    hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  };
}
