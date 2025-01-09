{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    android-studio.enable = lib.mkEnableOption "Enable Android Studio";
  };

  config = mkIf config.android-studio.enable {
    home.packages = with pkgs; [
      android-studio
    ];
  };
}