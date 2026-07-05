{
  config,
  lib,
  pkgs,
  ...
}: {
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [8080 3000 5000 1883 5001 25566];
    };
    networkmanager.enable = lib.mkDefault true;
    wireless.enable = lib.mkForce false;
    hostName = lib.mkDefault "nixos";

    extraHosts = ''
      34.127.16.105 install
      34.169.170.77 runner

      192.168.1.166 server
      10.0.1.198 vault.tiecia.com
    '';
  };
}
