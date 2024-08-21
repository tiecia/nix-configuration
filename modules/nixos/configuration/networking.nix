{
  config,
  lib,
  pkgs,
  ...
}: {
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [8080 3000 5000 1883];
    };
    networkmanager.enable = lib.mkDefault true;
    hostName = lib.mkDefault "nixos";
  };
}
