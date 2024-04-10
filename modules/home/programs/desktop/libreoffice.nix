{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    libreoffice.enable = lib.mkEnableOption "Enable libreoffice";
  };

  config = mkIf config.libreoffice.enable {
    home.packages = with pkgs; [
      libreoffice
    ];
  };
}
