{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./kde-plasma.nix
    ./hyprland/hyprland.nix
  ];
}
