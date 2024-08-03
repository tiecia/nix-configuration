{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    cheese.enable = lib.mkEnableOption "Enable cheese";
  };

  config = mkIf config.cheese.enable {
    home.packages = with pkgs; [
      cheese
    ];
  };
}
