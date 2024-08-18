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
    str=$(hyprctl clients | grep "FFPWA-01HZ3KX1QST5T15ECH5S0EDXQC")

    if [ -z "$str" ] && [ "$str" != " " ]; then
      firefoxpwa site launch 01HZ3KX1QST5T15ECH5S0EDXQC &
      # discord &
    fi
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

  show-notion = pkgs.writeShellScriptBin "show-notion" ''
    str=$(hyprctl clients | grep "FFPWA-01HXCTAGSEC8Z53A6Y9TFXNM7M")

    if [ -z "$str" ] && [ "$str" != " " ]; then
      firefoxpwa site launch 01HXCTAGSEC8Z53A6Y9TFXNM7M &
    fi
    hyprctl dispatch togglespecialworkspace notion
  '';
in {
  options = {
    special-workspaces = {
      enable = lib.mkEnableOption "Enable special workspaces";
    };
  };

  config = lib.mkIf config.special-workspaces.enable {
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

          "$mainMod, N, exec, ${show-notion}/bin/show-notion"
          "$mainMod Shift_L, G, movetoworkspace, special:notion"
        ];

        windowrulev2 = [
          "workspace special:spotify, title:(Spotify Premium)"

          "workspace special:discord, class:(discord)" # Discord native app
          "workspace special:discord, title:^(Discord)" # Discord PWA

          "workspace special:betterbird, class:(betterbird)"

          "workspace special:gitkraken, class:(GitKraken)"

          "workspace special:notion, initialTitle:(Notion)"
        ];
      };
    };
  };
}
