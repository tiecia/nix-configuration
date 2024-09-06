{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./docker.nix
    ./kde-connect.nix
    ./prism-launcher.nix
    ./steam.nix
    ./syncthing.nix
    ./wine.nix
    ./via.nix
  ];

  via.enable = lib.mkDefault true;
}
