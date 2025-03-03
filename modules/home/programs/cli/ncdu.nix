{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    ncdu.enable = mkEnableOption "Enable ncdu";
  };

  config = mkIf config.ncdu.enable {
    home.packages = with pkgs; [
      ncdu
    ];
  };
}
