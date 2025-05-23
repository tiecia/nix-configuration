{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    snapserver.enable = mkEnableOption "Enable snapserver";
    snapclient.enable = mkEnableOption "Enable snapclient";
  };

  config = {
    services.snapserver = {
      enable = config.snapserver.enable;
      openFirewall = true;
      codec = "flac";
      streams = {
        pipewire = {
          type = "pipe";
          location = "/run/snapserver/pipewire";
        };
      };
    };

    systemd.user.services.snapclient = mkIf config.snapclient.enable {
      wantedBy = [
        "pipewire.service"
      ];
      after = [
        "pipewire.service"
      ];
      serviceConfig = {
        ExecStart = "${pkgs.snapcast}/bin/snapclient -h ::1";
      };
    };
  };
}
