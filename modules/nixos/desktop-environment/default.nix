{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./kde-plasma.nix
    ./hyprland/hyprland.nix
  ];

  plasma.enable = lib.mkDefault true;
}
