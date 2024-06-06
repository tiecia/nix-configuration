{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hyprland-conf.nix
    ./ags.nix
  ];
}
