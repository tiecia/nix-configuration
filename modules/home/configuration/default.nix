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

  stylix.enable = lib.mkDefault true;
}
