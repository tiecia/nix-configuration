{
  config,
  lib,
  pkgs,
  ...
}: let
  startupScript = pkgs.pkgs.writeShellScriptBin "startup" ''
    bash ~/nix-configuration/modules/nixos/desktop-environment/hyprland/waybar/launch.sh
  '';
in
  with lib; {
    options = {
      hyprland-conf.enable = mkEnableOption "Enable hyprland configuration";
    };

    config = mkIf config.hyprland-conf.enable {
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          exec-once = ''${startupScript}/bin/start'';

          "$config-root" = "~/nix-configuration/modules/nixos/desktop-environment/hyprland";
          "$rofi-script" = "bash $config_root/../rofi.sh";

          "$terminal" = "kitty";
          "$fileManager" = "dolphin";
          "$menu" = "rofi -show drun";
          "$menu-all" = "rofi-script show run";
          "$waybar-switch" = "bash $config-root/waybar/themeswitcher.sh";
          "$screenshot-region" = "hyprshot -m region --clipboard-only";

          "$mainMod" = "SUPER";
          bind = "$mainMod, F, exec, firefox";

          # Some default env vars.
          env = [
            "XCURSOR_SIZE,24"
            "QT_QPA_PLATFORMTHEME,qt5ct" # change to qt6ct if you have that
          ];

          input = {
            kb_layout = "us";
            kb_variant = "";
            kb_model = "";
            kb_options = "ctrl:nocaps";
            kb_rules = "";
            follow_mouse = "1";
            touchpad = {
              natural_scroll = "no";
            };

            sensitivity = "-0.5";
          };

          general = {
            gaps_in = "2";
            gaps_out = "0";
            border_size = "0";
            "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            "col.inactive_border" = "rgba(595959aa)";

            layout = "dwindle";

            allow_tearing = "false";
          };

          decoration = {
            rounding = "10";
            blur = {
              enabled = "true";
              size = "3";
              passes = "1";
            };
            drop_shadow = "yes";
            shadow_range = "4";
            shadow_render_power = "3";
            "col.shadow" = "rgba(1a1a1aee)";
          };

          animations = {
            enabled = "yes";

            bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

            animation = [
              "windows, 1, 7, myBezier"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "borderangle, 1, 8, default"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
            ];
          };

          dwindle = {
            pseudotile = "yes";
            preserve_split = "yes";
          };

          master = {
            new_is_master = "true";
          };

          gestures = {
            workspace_swipe = "off";
          };

          misc = {
            force_default_wallpaper = "1";
          };

          device = {
            name = "epic-mouse-v1";
            sensitivity = "-0.5";
          };

          windowrulev2 = "suppressevent maximize, class:.*";
        };
      };

      home.packages = with pkgs; [
        # hello
      ];
    };
  }
