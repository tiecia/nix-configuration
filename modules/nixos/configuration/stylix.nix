{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  stylix = {
    enable = lib.mkDefault true;
    image = lib.mkDefault ../../../wallpapers/dark-water.jpg;
    polarity = "dark";

    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-mirage.yaml";

    autoEnable = false;

    targets = {
      # gnome.enable = lib.mkForce false;
      # spicetify.enable = lib.mkForce false;
      # gtk.enable = lib.mkForce true;
    };
  };
}
