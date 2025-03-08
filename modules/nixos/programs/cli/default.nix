{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./docker.nix
    ./nixos-cli.nix
    ./distrobox.nix
    ./netcoredbg.nix
  ];

  nixos-cli.enable = lib.mkDefault true;
}
