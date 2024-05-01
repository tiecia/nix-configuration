{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    zoom.enable = lib.mkEnableOption "Enable zoom";
  };

  config = mkIf config.zoom.enable {
    home.packages = with pkgs; [
      zoom-us
    ];
  };
}
