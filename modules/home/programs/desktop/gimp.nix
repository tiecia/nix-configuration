{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    gimp.enable = lib.mkEnableOption "Enable gimp";
  };

  config = mkIf config.gimp.enable {
    home.packages = with pkgs; [
      gimp
    ];
  };
}
