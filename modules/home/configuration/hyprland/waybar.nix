{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    widgets.waybar.enable = lib.mkEnableOption "Enable waybar desktop widgets";
  };

  config = let
    options = config.widgets.waybar;
    startupScript = pkgs.pkgs.writeShellScriptBin "startupScript" ''
      bash ~/nix-configuration/modules/nixos/desktop-environment/hyprland/waybar/launch.sh

      swww-daemon &

      swww img ~/nix-configuration/wallpapers/abstract-lines.jpg

      dunst
    '';

    config-root = "~/nix-configuration/modules/nixos/desktop-environment/hyprland"; # Get this from nix variable somehow;

    mainMod = "Super"; # Get this from parent config?

    waybar-theme-command = "${pkgs.bash}/bin/bash ${config-root}/waybar/themeswitcher.sh"; # Move this script to nix
    menu-command = "${pkgs.rofi-wayland}/bin/rofi -show drun -show-icons";
    menu-all-command = "${pkgs.rofi-wayland}/bin/rofi -show run --show-icons";
  in
    lib.mkIf options.enable {
      wayland.windowManager.hyprland = {
        settings = {
          exec-once = ''${startupScript}/bin/startupScript'';

          bind = [
            "${mainMod}, SUPER_L, exec, ${menu-command}"
            "${mainMod}, R, exec, ${menu-all-command}"
            "${mainMod}, B, exec, ${waybar-theme-command}"
          ];

          windowrulev2 = [
            "float,class:(pavucontrol)"
            "float,class:(.blueman-manager-wrapped)"
          ];
        };
      };

      home.packages = with pkgs; [
        pavucontrol
        blueman
        wlogout
        networkmanagerapplet
        swww # Wallpaper
      ];

      programs.bash = {
        enable = true;
        shellAliases = {
          widget-startup = "${pkgs.bash}/bin/bash ${startupScript}/bin/startupScript";
        };
      };
    };
}
