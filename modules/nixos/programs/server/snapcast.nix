{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    snapcast.enable = mkEnableOption "Enable snapcast audio streaming";
  };

  config = mkIf config.snapcast.enable {
    networking.firewall.allowedTCPPorts = [1704 1705 1780];
    environment.systemPackages = [
      pkgs.snapcast
    ];

    systemd.services.snapcast = {
      enable = true;
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.snapcast}/bin/snapserver";
      };
    };
  };
}
