{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    screen.enable = mkEnableOption "Enable screen";
  };

  config = mkIf config.screen.enable {
    home.packages = with pkgs; [
      screen
    ];
  };
}
