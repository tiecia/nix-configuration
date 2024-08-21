{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./logind.nix
    ./surface.nix
  ];

  options = {
    laptop-configuration.enable = lib.mkEnableOption "Enable laptop-configuration";
  };

  config = mkIf config.laptop-configuration.enable {
    surface.enable = lib.mkDefault false;
    services.upower.enable = lib.mkDefault true;
  };
}
