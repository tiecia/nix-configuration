{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  # options = {
  #   stylix = {
  #     enable = lib.mkEnableOption "Enable stylix";
  #     wallpaper = lib.mkOption {
  #       type = types.path;
  #       default = ../../../wallpapers/alena-aenami-lights1k1.jpg;
  #     };
  #   };
  # };

  # config = mkIf config.stylix.enable {
  stylix = {
    enable = lib.mkDefault true;
    image = lib.mkDefault ../../../wallpapers/alena-aenami-lights1k1.jpg;
    polarity = "dark";

    # base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-mirage.yaml";

    targets = {
      gnome.enable = lib.mkForce false;
      spicetify.enable = lib.mkForce false;
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
    };
  };
  # };
}
