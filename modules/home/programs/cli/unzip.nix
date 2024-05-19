{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    unzip.enable = mkEnableOption "Enable unzip";
  };

  config = mkIf config.unzip.enable {
    home.packages = with pkgs; [
      unzip
    ];
  };
}
