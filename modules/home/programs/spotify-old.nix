{
  config,
  lib,
  pkgs,
  spicetify-nix,
  ...
}: {
  home.packages = with pkgs; [
    spotify
  ];
}
