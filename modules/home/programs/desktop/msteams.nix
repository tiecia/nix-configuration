{
  config,
  lib,
  pkgs,
  pkgs-master,
  ...
}:
with lib; {
  options = {
    msteams.enable = lib.mkEnableOption "Enable msteams";
  };

  config = mkIf config.msteams.enable {
    home.packages = with pkgs-master; [
      teams-for-linux
    ];
  };
}
