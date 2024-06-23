{
  config,
  lib,
  pkgs,
  pkgs-master,
  ...
}:
with lib; {
  options = {
    arduino-ide.enable = lib.mkEnableOption "Enable arduino-ide";
  };

  config = mkIf config.arduino-ide.enable {
    home.packages = with pkgs; [
      arduino-ide
    ];
  };
}
