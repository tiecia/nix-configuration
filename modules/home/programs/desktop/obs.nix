{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    obs.enable = lib.mkEnableOption "Enable obs";
  };

  config = mkIf config.obs.enable {
    home.packages = with pkgs; [
      obs-studio
    ];
  };
}
