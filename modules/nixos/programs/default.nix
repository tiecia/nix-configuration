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
    ./nixos-cli.nix
  ];

  via.enable = lib.mkDefault true;
  nixos-cli.enable = lib.mkDefault true;
}
