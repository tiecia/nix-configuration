{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    hyprland.enable = mkEnableOption "Enable hyprland";
  };

  config = mkIf config.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
    };
  };
}
