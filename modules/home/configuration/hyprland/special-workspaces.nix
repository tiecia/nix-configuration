{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  show-spotify = pkgs.writeShellScriptBin "show-spotify" ''
    spotify &
    hyprctl dispatch togglespecialworkspace spotify
  '';
in {
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        "$mainMod, S, exec, ${show-spotify}/bin/show-spotify"
        # "$mainMod, S, togglespecialworkspace, spotify"
        "$mainMod Shift_L, S, movetoworkspace, special:spotify"
      ];
    };
  };
}
