{
  config,
  lib,
  pkgs,
  pkgs-master,
  ...
}:
with lib; {
  options = {
    wpsoffice.enable = lib.mkEnableOption "Enable wpsoffice";
  };

  config = mkIf config.wpsoffice.enable {
    home.packages = [
      pkgs-master.wpsoffice
    ];
  };
}
