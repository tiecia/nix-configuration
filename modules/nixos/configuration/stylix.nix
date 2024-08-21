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
    image = lib.mkDefault ../../../wallpapers/alena-aenami-lights1k1.jpg;
    polarity = "dark";

    targets = {
      gnome.enable = lib.mkForce false;
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
    };
  };
  # };
}
