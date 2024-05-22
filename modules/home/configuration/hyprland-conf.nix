{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    hyprland-conf.enable = mkEnableOption "Enable hyprland configuration";
  };

  config = mkIf config.hyprland-conf.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mainMod" = "SUPER";
        bind = "$mainMod, F, exec, firefox";
      };
    };
  };
}
