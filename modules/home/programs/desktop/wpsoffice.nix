{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    wpsoffice.enable = lib.mkEnableOption "Enable wpsoffice";
  };

  config = mkIf config.wpsoffice.enable {
    home.packages = with pkgs; [
      wpsoffice
    ];
  };
}
