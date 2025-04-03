{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; {
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];

  stylix = {
    image = lib.mkDefault ../../../wallpapers/dark-water.jpg;
    autoEnable = false;
    targets = {
      kitty.enable = lib.mkForce true;
      alacritty.enable = lib.mkForce true;
      gtk.enable = false;
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 12;
    };
  };
}
