# DNS lookup tool
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    traceroute.enable = mkEnableOption "Enable traceroute";
  };

  config = mkIf config.wget.enable {
    home.packages = with pkgs; [
      traceroute
    ];
  };
}
