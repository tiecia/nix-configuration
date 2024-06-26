{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
in
  with lib; {
    options = {
      hyprland-conf = {
        enable = mkEnableOption "Enable hyprland configuration";
        monitor = mkOption {
          type = types.either types.str (types.listOf types.str);
          default = ",preferred,auto,auto";
          description = "Hyprland 'monitor' option";
        };
        extraBind = mkOption {
          type = types.either types.str (types.listOf types.str);
          default = [];
          description = "Extra binds to add to config";
        };
        extraWindowrulev2 = mkOption {
          type = types.listOf types.str;
          default = [];
          description = "Extra windowrulev2 optios to add to config";
        };
        numWorkspaces = mkOption {
          type = types.int;
          default = 7;
          description = "Number of workspaces per monitor";
        };
        mouse = {
          sensitivity = mkOption {
            type = types.either types.int types.float;
            default = 0;
            description = "Mouse sensitivity";
          };
        };
        widgets = mkOption {
          type = types.enum ["waybar" "ags"];
          default = "waybar";
        };
      };
    };

    config = let
      options = config.hyprland-conf;
      terminal = "${pkgs.kitty}/bin/kitty";
      fileManager = "${pkgs.dolphin}/bin/dolphin";
      # Screenshot
      # grim = "${pkgs.grim}/bin/grim";
      # slurp = "${pkgs.slurp}/bin/slurp";
      # copy = "${pkgs.wl-clipboard}/bin/wl-copy";
      # screenshot-region = "${grim} -l 0 -g \"$(${slurp})\" - | ${copy}";
    in
      mkIf options.enable {
        #widgets.waybar.enable = true;
        widgets.ags.enable = true;

        wayland.windowManager.hyprland = {
          enable = true;
          package = inputs.hyprland.packages.${pkgs.system}.hyprland;
          settings = {
            monitor = options.monitor;

            plugin = {
              hyprsplit = {
                num_workspaces = options.numWorkspaces;
              };
            };

            "$screenshot-region" = "grim -l 0 -g \"$(slurp)\" - | wl-copy";
            "$media-playpause" = "playerctl play-pause";
            "$media-next" = "playerctl next";
            "$media-prev" = "playerctl previous";

            "$mainMod" = "Super";

            # Use the program "wev" to get key names
            bind =
              [
                # See https://wiki.hyprland.org/Configuring/Binds/ for more
                "$mainMod, Q, exec, ${terminal}"
                "$mainMod, F, exec, firefox"
                "$mainMod, C, killactive,"
                "$mainMod, M, exit,"
                "$mainMod, E, exec, ${fileManager}"
                "$mainMod, V, togglefloating,"
                "$mainMod, J, togglesplit," # dwindle

                "$mainMod&Shift_L, S, exec, $screenshot-region"

                # Move focus with mainMod + arrow keys
                "$mainMod, left, movefocus, l"
                "$mainMod, right, movefocus, r"
                "$mainMod, up, movefocus, u"
                "$mainMod, down, movefocus, d"

                # Example special workspace (scratchpad)
                "$mainMod, S, togglespecialworkspace, magic"
                "$mainMod Ctrl_L, S, movetoworkspace, special:magic"
                "Alt_L, Tab, workspace, previous"
                "$mainMod Alt_L, F, fullscreen"

                # Move window position with mainMod + Ctrl_L + left/right
                "$mainMod SHIFT, left, movewindow, l"
                "$mainMod SHIFT, right, movewindow, r"
                "$mainMod SHIFT, up, movewindow, u"
                "$mainMod SHIFT, down, movewindow, d"

                ",XF86AudioPlay, exec, $media-playpause"
                ",XF86AudiNext, exec, $media-next"
                ",XF86AudioPrev, exec, $media-prev"
                "$mainMod Ctrl_L, slash, exec, $media-playpause" #Binds the "/" key
                "$mainMod Ctrl_L, left, exec, $media-prev"
                "$mainMod Ctrl_L, right, exec, $media-next"

                ",mouse:276, exec, $media-playpause" # Logitech MX Master side button play pause
              ]
              ++ (
                builtins.concatLists (builtins.genList (
                    x: let
                      ws = let
                        c = (x + 1) / options.numWorkspaces;
                      in
                        builtins.toString (x + 1 - (c * options.numWorkspaces));
                    in [
                      "$mainMod, ${toString (x + 1)}, split:workspace, ${toString (x + 1)}"
                      "$mainMod SHIFT, ${toString (x + 1)}, split:movetoworkspace, ${toString (x + 1)}"
                    ]
                  )
                  options.numWorkspaces)
              )
              ++ options.extraBind;

            bindm = [
              # Scroll through existing workspaces with mainMod + scroll
              # "$mainMod, mouse_down, workspace, e+1"
              # "$mainMod, mouse_up, workspace, e-1"

              # Move/resize windows with mainMod + LMB/RMB and dragging
              "$mainMod, mouse:272, movewindow"
              "$mainMod, mouse:273, resizewindow"
              "$mainMod Alt_L, mouse:272, resizewindow"
            ];

            binds = {
              allow_workspace_cycles = true;
            };

            # Some default env vars.
            env = [
              "XCURSOR_SIZE,24"
              "QT_QPA_PLATFORMTHEME,qt5ct" # change to qt6ct if you have that
              "ELECTRON_OZONE_PLATFORM_HINT,auto"

              # "WLR_NO_HARDWARE_CURSORS,1" # This has been deprecated in favor of the cursor variable.
              "NIXOS_OZONE_WL,1"

              # These variables were are recomended by the Hyprland docs for getting Nvidia to work https://wiki.hyprland.org/Nvidia/
              "XDG_SESSION_TYPE,wayland"
              # Some of these are problematic on non-nvidia systems, they don't seem to do anything on nvidia systems to I am disabling them for now.
              "LIBVA_DRIVER_NAME,nvidia" # This fixes electron apps taking a long time to start.
              # "GBM_BACKEND,nvidia-drm"
              # "__GLX_VENDOR_LIBRARY_NAME,nvidia"

              # This is used by nvidia-vaapi-driver
              # "NVD_BACKEND,direct"

              # These vars force Firefox to use the nvidia-vaapi-driver for hardware acceleration.
              # "MOZ_DISABLE_RDD_SANDBOX,1"
              # "LIBVA_DRIVER_NAME,nvidia"
            ];

            cursor = {
              no_hardware_cursors = "true";
            };

            input = {
              kb_layout = "us";

              kb_options = "ctrl:nocaps";

              follow_mouse = "1";
              accel_profile = "flat";
              force_no_accel = true; # Remove if having trouble with mouse cursor sync
              touchpad = {
                natural_scroll = "yes";
                scroll_factor = "0.8";
              };

              sensitivity = "${toString options.mouse.sensitivity}"; # -1.0 to 1.0, 0 means no modification.
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

            gestures = {
              # See https://wiki.hyprland.org/Configuring/Variables/ for more
              workspace_swipe = "on";
              workspace_swipe_forever = true;
              workspace_swipe_cancel_ratio = 0.3;
            };

            misc = {
              # See https://wiki.hyprland.org/Configuring/Variables/ for more
              force_default_wallpaper = "0";
            };

            # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
            windowrulev2 =
              [
                "suppressevent maximize, class:.*"
                "float,class:(betterbird),title:^(Write:)"
              ]
              ++ options.extraWindowrulev2;

            debug = {
              disable_logs = false;
            };
          };
          plugins = [
            inputs.hyprsplit.packages.${pkgs.system}.hyprsplit
          ];
        };

        qt = {
          enable = true;
          platformTheme.name = "kde";
          style.name = "breeze";
        };

        # fonts.fontconfig.enable = true;

        xdg.portal = {
          enable = true;
          extraPortals = [pkgs.xdg-desktop-portal-gtk];
        };

        programs.bash = {
          enable = true;
          shellAliases = {
            hypr = "vi ~/nix-configuration/modules/home/configuration/hyprland/hyprland-conf.nix";
          };
        };

        # services.dunst.enable = true;

        # ags.enable = true;

        home.packages = with pkgs; [
          (pkgs.waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
          }))
          kitty
          dolphin
          xwaylandvideobridge
          playerctl # Media player CLI controls
          wev

          # Screenshot tools
          grim # Screenshot grabber
          slurp # Region selector
          wl-clipboard # Copy image to clipboard

          # nvidia-vaapi-driver
          ffmpeg
        ];
      };
  }
