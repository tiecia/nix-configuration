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

  config = mkIf config.stylixhm.enable {
    stylix = {
      autoEnable = false;
      targets = {
        kitty.enable = true;
        alacritty.enable = true;
        gtk.enable = true;
      };
    };
  };
}
