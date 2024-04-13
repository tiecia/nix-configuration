{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    bootloader.enable = lib.mkEnableOption "Enable bootloader options";
  };

  config = mkIf config.bootloader.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
