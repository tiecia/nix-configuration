{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./stylix.nix
  ];

  options = {
    desktop-configuration.enable = lib.mkEnableOption "Enable desktop-configuration";
  };

  config = mkIf config.desktop-configuration.enable {
    stylix.enable = lib.mkDefault true;
  };
}
