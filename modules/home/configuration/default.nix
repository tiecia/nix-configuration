{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./xbindkeys/xbindkeys.nix
    ./hyprland-conf.nix
  ];
}
