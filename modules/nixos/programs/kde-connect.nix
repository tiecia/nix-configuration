{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    kde-connect.enable = mkEnableOption "Enable kde-connect";
  };

  config = mkIf config.kde-connect.enable {
    environment.systemPackages = with pkgs; [
      kdeconnect
    ];

    networking.firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
    };
  };
}
