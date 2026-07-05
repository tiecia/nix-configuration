{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    portracker.enable = mkEnableOption "Enable portracker in container";
  };

  config = mkIf config.portracker.enable {
    networking.firewall.allowedTCPPorts = [4999];

    virtualisation.oci-containers = {
      backend = "docker";

      containers.portracker = {
        autoStart = true;
        volumes = [
          "./portracker-data:/data"
          "/var/run/docker.sock:/var/run/docker.sock:ro"
        ];
        environment.TZ = "America/Los_Angeles";
        image = "mostafawahied/portracker:latest";
        ports = ["0.0.0.0:4999:4999"];
        capabilities = {
          SYS_PTRACE = true;
          SYS_ADMIN = true;
        };
        extraOptions = [
          # "--security-opt apparmor=unconfined"
          # "--pid host"
          # "--restart=unless-stopped"
        ];
      };
    };
  };
}
