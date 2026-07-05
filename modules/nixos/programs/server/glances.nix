{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    glances.enable = mkEnableOption "Enable glances servers";
  };

  config = mkIf config.glances.enable {
    services.glances = {
      enable = true;
      openFirewall = true;
      extraArgs = ["--webserver"];
    };

    systemd.services.glances-rpc = {
      description = "Glances RPC Server";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${pkgs.glances}/bin/glances --server --port 61209";
        DynamicUser = true;
        Restart = "on-failure";
      };
    };

    # Port for RPC server
    networking.firewall.allowedTCPPorts = [61209];
  };
}
