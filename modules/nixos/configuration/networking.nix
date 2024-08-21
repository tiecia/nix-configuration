{
  config,
  lib,
  pkgs,
  ...
}: {
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [8080 3000];
    };
    networkmanager.enable = lib.mkDefault true;
    hostName = lib.mkDefault "nixos";
  };
}
