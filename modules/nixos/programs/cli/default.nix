{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./docker.nix
    ./nixos-cli.nix
  ];

  nixos-cli.enable = lib.mkDefault true;
}
