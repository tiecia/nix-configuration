{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    stylixhm.enable = mkEnableOption "Enable stylix hm configuration";
  };

  # imports = [
  #   stylix.homeManagerModules.stylix
  # ];

  config = mkIf config.stylixhm.enable {
    stylix = {
      enable = true;
      image = lib.mkDefault ../../../wallpapers/dark-water.jpg;
      autoEnable = false;
      targets = {
        kitty.enable = lib.mkForce true;
        alacritty.enable = lib.mkForce true;
        gtk.enable = true;
      };
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 12;
      };
    };
  };
}
