{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    zen.enable = lib.mkEnableOption "Enable zoom";
  };

  config = mkIf config.zoom.enable {
    home.packages = with pkgs; [
      inputs.zen-browser.packages.${pkgs.system}.default
    ];
  };
}
