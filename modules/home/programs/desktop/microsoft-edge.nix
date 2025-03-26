{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    microsoft-edge.enable = lib.mkEnableOption "Enable microsoft-edge";
  };

  config = mkIf config.microsoft-edge.enable {
    home.packages = with pkgs; [
      microsoft-edge
    ];
  };
}
