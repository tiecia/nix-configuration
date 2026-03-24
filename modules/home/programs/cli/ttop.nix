{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    ttop.enable = mkEnableOption "Enable ttop";
  };

  config = mkIf config.ttop.enable {
    home.packages = with pkgs; [
      ttop
    ];
  };
}
