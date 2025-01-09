{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    arduino-ide.enable = lib.mkEnableOption "Enable arduino-ide";
  };

  config = mkIf config.arduino-ide.enable {
    home.packages = with pkgs; [
      arduino-ide
      python312
      python312Packages.serialio
      python312Packages.pyserial
    ];
  };
}
