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
      34.127.16.105 install
      34.169.170.77 runner

      10.0.0.179 server
    '';
  };
}
