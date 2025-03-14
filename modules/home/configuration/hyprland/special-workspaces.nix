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
    # str=$(hyprctl clients | grep "FFPWA-01HZ3KX1QST5T15ECH5S0EDXQC")

    # if [ -z "$str" ] && [ "$str" != " " ]; then
      # firefoxpwa site launch 01HZ3KX1QST5T15ECH5S0EDXQC &
      # discord --use-gl=desktop &
    # fi
    webcord &
    hyprctl dispatch togglespecialworkspace discord
  '';

  show-mail = pkgs.writeShellScriptBin "show-mail" ''
    thunderbird &
    hyprctl dispatch togglespecialworkspace mail
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

          "$mainMod, M, exec, ${show-mail}/bin/show-mail"
          "$mainMod Shift_L, M, movetoworkspace, special:mail"

          "$mainMod, G, exec, ${show-gitkraken}/bin/show-gitkraken"
          "$mainMod Shift_L, G, movetoworkspace, special:gitkraken"

          "$mainMod, N, exec, ${show-notion}/bin/show-notion"
          "$mainMod Shift_L, G, movetoworkspace, special:notion"
        ];

        windowrulev2 = [
          "workspace special:spotify, title:(Spotify Premium)"

          "workspace special:discord, class:(discord)" # Discord native app
          "workspace special:discord, title:^(Discord)" # Discord PWA

          "workspace special:mail, class:(thunderbird)"

          "workspace special:gitkraken, class:(GitKraken)"

          "workspace special:notion, initialTitle:(Notion)"
        ];
      };
    };
  };
}
