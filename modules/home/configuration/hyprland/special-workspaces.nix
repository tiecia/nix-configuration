{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        "$mainMod, S, togglespecialworkspace, spotify"
        "$mainMod Shift_L, S, movetoworkspace, special:spotify"
      ];
    };
  };
}
