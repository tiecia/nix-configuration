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
  show-discord = pkgs.writeShellScriptBin "show-discord" ''
    discord &
    hyprctl dispatch togglespecialworkspace discord
  '';
  show-betterbird = pkgs.writeShellScriptBin "show-betterbird" ''
    betterbird &
    hyprctl dispatch togglespecialworkspace betterbird
  '';
  show-gitkraken = pkgs.writeShellScriptBin "show-gitkraken" ''
    gitkraken &
    hyprctl dispatch togglespecialworkspace gitkraken
  '';
in {
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        "$mainMod, S, exec, ${show-spotify}/bin/show-spotify"
        "$mainMod Shift_L, S, movetoworkspace, special:spotify"

        "$mainMod, D, exec, ${show-discord}/bin/show-discord"
        "$mainMod Shift_L, D, movetoworkspace, special:discord"

        "$mainMod, B, exec, ${show-betterbird}/bin/show-betterbird"
        "$mainMod Shift_L, B, movetoworkspace, special:betterbird"

        "$mainMod, G, exec, ${show-gitkraken}/bin/show-gitkraken"
        "$mainMod Shift_L, G, movetoworkspace, special:gitkraken"
      ];

      windowrulev2 = [
        "workspace special:spotify, title:(Spotify Premium)"

        "workspace special:discord, class:(discord)" # Discord native app
        "workspace special:discord, title:^(Discord)" # Discord PWA

        "workspace special:betterbird, class:(betterbird)"

        "workspace special:gitkraken, class:(GitKraken)"
      ];
    };
  };
}
