{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    nh.enable = mkEnableOption "Enable nh";
  };

  config = lib.mkIf config.nh.enable {
    home.packages = with pkgs; [
      nh
    ];
  };
}
