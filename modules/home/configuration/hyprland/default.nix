{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hyprland-conf.nix
    ./ags-widgets.nix
  ];
}
