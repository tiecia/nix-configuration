{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    xbindkeys.enable = mkEnableOption "Enable xbindkeys";

    # xbindkeys.mxmaster-playpause.enable = mkEnableOption "Remap forward button to play/pause on MX Master";
  };

  config = mkIf config.xbindkeys.enable {
    home.file.".xbindkeysrc".source = ./xbindkeysrc;

    home.packages = with pkgs; [
      xbindkeys
    ];
  };
}
