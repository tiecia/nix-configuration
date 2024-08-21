{
  config,
  lib,
  pkgs,
  ...
}: {
  users.users.tiec = {
    isNormalUser = true;
    description = "tiec";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker" # Gives account access to the docker socket
      "dialout" # Gives account access to serial ports
    ];
    packages = with pkgs; [
      home-manager
    ];
  };
}
