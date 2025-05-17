{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    music_assistant.enable = mkEnableOption "Enable music assistant server in container";
  };

  config = mkIf config.music_assistant.enable {
    networking.firewall.allowedTCPPorts = [8095];

    virtualisation.oci-containers = {
      backend = "docker";
      containers.musicassistant = {
        volumes = ["music-assistant-server/data:/data/"];
        image = "ghcr.io/music-assistant/server:stable"; # Warning: if the tag does not change, the image will not be updated
        extraOptions = [
          "--network=host"
          # "--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
        ];
      };
    };
  };
}
