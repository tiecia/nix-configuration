{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    filezilla.enable = lib.mkEnableOption "Enable filezilla";
  };

  config = mkIf config.filezilla.enable {
    home.packages = with pkgs; [
      filezilla
    ];
  };
}
