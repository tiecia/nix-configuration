{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    msteams.enable = lib.mkEnableOption "Enable msteams";
  };

  config = mkIf config.msteams.enable {
    home.packages = with pkgs; [
      teams-for-linux
    ];
  };
}
