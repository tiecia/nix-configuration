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
        };
      };

      home.packages = with pkgs; [
        # hello
      ];
    };
  }
