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
        kitty.enable = lib.mkForce true;
        alacritty.enable = lib.mkForce true;
        gtk.enable = true;
      };
    };
  };
}
