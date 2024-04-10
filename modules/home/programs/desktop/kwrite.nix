{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    kwrite.enable = lib.mkEnableOption "Enable kwrite";
  };

  config = mkIf config.kwrite.enable {
    home.packages = with pkgs; [
      libsForQt5.kwrited
    ];
  };
}
