{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./xbindkeys/xbindkeys.nix
    ./hyprland
    ./stylix.nix
  ];

  stylixhm.enable = lib.mkDefault true;
}
