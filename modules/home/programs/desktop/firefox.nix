{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    firefox.enable = lib.mkEnableOption "Enable firefox";
  };

  config = mkIf config.firefox.enable {
    home.packages = with pkgs; [
      firefox
    ];
  };
}
