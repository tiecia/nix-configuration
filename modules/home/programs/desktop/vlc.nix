{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    vlc.enable = lib.mkEnableOption "Enable vlc";
  };

  config = mkIf config.vlc.enable {
    home.packages = with pkgs; [
      vlc
    ];
  };
}
