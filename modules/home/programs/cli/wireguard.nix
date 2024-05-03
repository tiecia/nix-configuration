{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    wireguard.enable = mkEnableOption "Enable wireguard";
  };

  config = mkIf config.wireguard.enable {
    home.packages = with pkgs; [
      wireguard-tools
    ];
  };
}
