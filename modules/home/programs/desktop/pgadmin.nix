{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    pgadmin.enable = lib.mkEnableOption "Enable pgadmin";
  };

  config = mkIf config.pgadmin.enable {
    home.packages = with pkgs; [
      pgadmin4
    ];
  };
}
