{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./kde-plasma.nix
  ];

  plasma.enable = lib.mkDefault true;
}
