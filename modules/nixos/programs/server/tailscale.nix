{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    tailscale.enable = mkEnableOption "Enable tailscale client";
  };

  config = {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "server";
    };
  };
}
