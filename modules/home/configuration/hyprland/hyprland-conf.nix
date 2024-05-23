{
  config,
  lib,
  pkgs,
  split-monitor-workspaces,
  hyprsplit,
  ...
}: let
  startupScript = pkgs.pkgs.writeShellScriptBin "startup" ''
    bash ~/nix-configuration/modules/nixos/desktop-environment/hyprland/waybar/launch.sh
  '';
  # plugins = inputs.hyprland-plugins.packages."${pkgs.system}";
in
  with lib; {
    options = {
      hyprland-conf.enable = mkEnableOption "Enable hyprland configuration";
    };

    config = mkIf config.hyprland-conf.enable {
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          monitor = [
            "DP-1,2560x1080@144,0x0,1" # Main Ultrawide
            "HDMI-A-1,2560x1080@60,0x-1080,1" #Top Ultrawide
            "HDMI-A-2,1920x1080@60,-1080x-840,1,transform,1" #Left Vertical
            "DP-2,1920x1080@60,2560x-700,1,transform,1" #Right Vertical
          ];

          # See https://wiki.hyprland.org/Configuring/Keywords/ for more
          # For all categories, see https://wiki.hyprland.org/Configuring/Variables/

          exec-once = ''${startupScript}/bin/startup'';

          # See https://wiki.hyprland.org/Configuring/Keywords/ for more
          "$config-root" = "~/nix-configuration/modules/nixos/desktop-environment/hyprland";
          "$rofi-script" = "bash $config_root/../rofi.sh";

          "$terminal" = "kitty";
          "$fileManager" = "dolphin";
          "$menu" = "rofi -show drun";
          "$menu-all" = "rofi-script show run";
          "$waybar-switch" = "bash $config-root/waybar/themeswitcher.sh";
          "$screenshot-region" = "hyprshot -m region --clipboard-only";

          "$mainMod" = "Super";
          bind = [
            # See https://wiki.hyprland.org/Configuring/Binds/ for more
            "$mainMod, Q, exec, $terminal"
            "$mainMod, F, exec, firefox"
            "$mainMod, C, killactive,"
            "$mainMod, M, exit,"
            "$mainMod, E, exec, $fileManager"
            "$mainMod, V, togglefloating,"
            "$mainMod, SUPER_L, exec, $menu"
            "$mainMod, R, exec, $menu-all"
            "$mainMod, P, pseudo," # dwindle
            "$mainMod, J, togglesplit," # dwindle

            "$mainMod, B, exec, $waybar-switch"
            "$mainMod&Shift_L, S, exec, $screenshot-region"

            # Move focus with mainMod + arrow keys
            "$mainMod, left, movefocus, l"
            "$mainMod, right, movefocus, r"
            "$mainMod, up, movefocus, u"
            "$mainMod, down, movefocus, d"

            # Switch workspaces with mainMod + [0-9]
            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"

            # Move active window to a workspace with mainMod + SHIFT + [0-9]
            "$mainMod SHIFT, 1, movetoworkspace, 1"
            "$mainMod SHIFT, 2, movetoworkspace, 2"
            "$mainMod SHIFT, 3, movetoworkspace, 3"
            "$mainMod SHIFT, 4, movetoworkspace, 4"
            "$mainMod SHIFT, 5, movetoworkspace, 5"
            "$mainMod SHIFT, 6, movetoworkspace, 6"
            "$mainMod SHIFT, 7, movetoworkspace, 7"
            "$mainMod SHIFT, 8, movetoworkspace, 8"
            "$mainMod SHIFT, 9, movetoworkspace, 9"
            "$mainMod SHIFT, 0, movetoworkspace, 10"

            # Example special workspace (scratchpad)
            "$mainMod, S, togglespecialworkspace, magic"
            # bind = $mainMod SHIFT, S, movetoworkspace, special:magic

            # Scroll through existing workspaces with mainMod + scroll
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
          ];

          bindm = [
            # Move/resize windows with mainMod + LMB/RMB and dragging
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];

          # Some default env vars.
          env = [
            "XCURSOR_SIZE,24"
            "QT_QPA_PLATFORMTHEME,qt5ct" # change to qt6ct if you have that
          ];

          input = {
            kb_layout = "us";

            kb_options = "ctrl:nocaps";

            follow_mouse = "1";
            touchpad = {
              natural_scroll = "no";
            };

            sensitivity = "-0.5"; # -1.0 to 1.0, 0 means no modification.
          };

          general = {
            gaps_in = "2";
            gaps_out = "0";
            border_size = "0";
            "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            "col.inactive_border" = "rgba(595959aa)";

            layout = "dwindle";

            # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
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
            # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

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
            # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
            pseudotile = "yes";
            preserve_split = "yes";
          };

          master = {
            # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
            new_is_master = "true";
          };

          gestures = {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            workspace_swipe = "off";
          };

          misc = {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            force_default_wallpaper = "1";
          };

          # Example per-input-device config
          # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
          device = {
            name = "epic-mouse-v1";
            sensitivity = "-0.5";
          };

          # Example windowrule v1
          # windowrule = float, ^(kitty)$
          # Example windowrule v2
          # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
          # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
          windowrulev2 = "suppressevent maximize, class:.*";
        };
        plugins = [
          hyprsplit.packages.${pkgs.system}.hyprsplit
          # split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
        ];
      };

      home.packages = with pkgs; [
        # hello
      ];
    };
  }
