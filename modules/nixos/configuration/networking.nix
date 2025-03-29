{
  config,
  lib,
  pkgs,
  ...
}: {
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [8080 3000 5000 1883 5001];
    };
    networkmanager.enable = lib.mkDefault true;
    wireless.enable = lib.mkForce false;
    hostName = lib.mkDefault "nixos";

    extraHosts = ''
      34.169.118.232 install
      104.198.96.36 runner
    '';
  };
}
