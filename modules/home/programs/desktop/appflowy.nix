{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    appflowy.enable = lib.mkEnableOption "Enable appflowy";
  };

  config = mkIf config.appflowy.enable {
    home.packages = with pkgs; [
      appflowy
    ];
  };
}
