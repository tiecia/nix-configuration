{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    solaar.enable = lib.mkEnableOption "Enable solaar";
  };

  config = mkIf config.solaar.enable {
    home.packages = with pkgs; [
      solaar
    ];
  };
}
