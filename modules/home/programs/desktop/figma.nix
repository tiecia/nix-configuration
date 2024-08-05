{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    figma.enable = lib.mkEnableOption "Enable figma";
  };

  config = mkIf config.figma.enable {
    home.packages = with pkgs; [
      figma-linux
    ];
  };
}
