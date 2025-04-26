# DNS lookup tool
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    dig.enable = mkEnableOption "Enable dig";
  };

  config = mkIf config.wget.enable {
    home.packages = with pkgs; [
      dig
    ];
  };
}
