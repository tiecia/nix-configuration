{
  config,
  lib,
  system,
  ...
}:
with lib; {
  options = {
    winapps.enable = mkEnableOption "Enable winapps";
  };

  config = mkIf config.winapps.enable {
    environment.systemPackages = [
      winapps.packages.${system}.winapps
      winapps.packages.${system}.winapps-launcher
    ];
  };
}
