{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    via.enable = mkEnableOption "Enable via";
  };

  config = mkIf config.via.enable {
    environment.systemPackages = [
      pkgs.via
    ];

    services.udev.packages = [pkgs.via];
    hardware.keyboard.qmk.enable = true;
  };
}
