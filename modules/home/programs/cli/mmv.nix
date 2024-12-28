{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    mmv.enable = mkEnableOption "Enable mmv";
  };

  config = mkIf config.mmv.enable {
    home.packages = with pkgs; [
      mmv
    ];
  };
}
