{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    inkscape.enable = lib.mkEnableOption "Enable inkscape";
  };

  config = mkIf config.inkscape.enable {
    home.packages = with pkgs; [
      inkscape
    ];
  };
}
