{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    anytype.enable = lib.mkEnableOption "Enable anytype";
  };

  config = mkIf config.anytype.enable {
    home.packages = with pkgs; [
      anytype
    ];
  };
}
