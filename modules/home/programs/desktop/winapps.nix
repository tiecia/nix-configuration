{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    winapps.enable = lib.mkEnableOption "Enable winapps";
  };

  config = mkIf config.winapps.enable {
    home.packages = with pkgs; [
      dialog
      freerdp
      iproute2
      libnotify
      netcat-gnu
    ];
  };
}
