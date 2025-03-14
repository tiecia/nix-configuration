{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./kde-connect.nix
    ./prism-launcher.nix
    ./steam.nix
    ./syncthing.nix
    ./wine.nix
    ./via.nix
    ./winapps.nix
    ./wireshark.nix
    ./virtualbox.nix
  ];

  via.enable = lib.mkDefault true;
  kde-connect.enable = lib.mkDefault true;
  steam.enable = lib.mkDefault true;
  prism-launcher.enable = lib.mkDefault true;
  syncthing.enable = lib.mkDefault true;
  wine.enable = lib.mkDefault true;
  winapps.enable = lib.mkDefault true;
  wireshark.enable = lib.mkDefault true;
  virtualbox.enable = lib.mkDefault true;
}
