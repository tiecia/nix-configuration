{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    onlyoffice.enable = lib.mkEnableOption "Enable onlyoffice-desktopeditors";
  };

  config = mkIf config.onlyoffice.enable {
    home.packages = with pkgs; [
      onlyoffice-desktopeditors
    ];
  };
}
