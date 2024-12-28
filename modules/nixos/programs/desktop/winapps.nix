{
  config,
  lib,
  # system,
  winapps-pkgs,
  ...
}:
with lib; {
  options = {
    winapps.enable = mkEnableOption "Enable winapps";
  };

  config = mkIf config.winapps.enable {
    environment.systemPackages = [
      winapps-pkgs.winapps
      winapps-pkgs.winapps-launcher
    ];
  };
}
