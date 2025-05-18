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
    services.snapserver = {
      enable = false;
      openFirewall = true;
      codec = "flac";
      streams = {
        pipewire = {
          type = "pipe";
          location = "/run/snapserver/pipewire";
        };
      };
    };
    #   networking.firewall.allowedTCPPorts = [1704 1705 1780];
    #   environment.systemPackages = [
    #     pkgs.snapcast
    #     pkgs.snapweb
    #   ];
    #
    #   systemd.services.snapcast = {
    #     enable = true;
    #     wantedBy = ["multi-user.target"];
    #     serviceConfig = {
    #       Type = "simple";
    #       ExecStart = "${pkgs.snapcast}/bin/snapserver";
    #     };
    #   };
  };
}
