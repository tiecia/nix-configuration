{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./docker.nix
    ./nixos-cli.nix
    ./distrobox.nix
  ];

  nixos-cli.enable = lib.mkDefault true;
}
