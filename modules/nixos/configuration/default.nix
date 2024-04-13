{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./bluetooth.nix
    ./bootloader.nix
  ];

  bluetooth.enable = lib.mkDefault true;
  bootloader.enable = lib.mkDefault true;
}
