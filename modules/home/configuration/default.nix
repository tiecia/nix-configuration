{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./xbindkeys/xbindkeys.nix
    ./hyprland/hyprland-conf.nix
  ];
}
