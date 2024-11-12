{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    devenv.enable = mkEnableOption "Enable devenv";
  };

  config = mkIf config.eza.enable {
    home.packages = with pkgs; [
      devenv
    ];
  };
}
