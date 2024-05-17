{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./kde-plasma.nix
    ./hyprland.nix
  ];

  plasma.enable = lib.mkDefault true;
}
