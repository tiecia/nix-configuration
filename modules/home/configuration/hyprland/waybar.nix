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

    mainMod = "SUPER"; # Get this from parent config?

    waybar-theme-command = "bash ${config-root}/waybar/themeswitcher.sh";
    menu-command = "${pkgs.rofi} -show drun -show-icons";
    menu-all-command = "rofi -show run --show-icons";
  in
    lib.mkIf options.enable {
      wayland.windowManager.hyprland = {
        settings = {
          exec-once = ''${startupScript}/bin/startupScript'';

          # "$waybar-switch" = "bash $config-root/waybar/themeswitcher.sh";
          # "$menu" = "rofi -show drun -show-icons";
          # "$menu-all" = "rofi show run -show-icons";

          bind = [
            "${mainMod}, SUPER_L, exec, ${menu-command}"
            "${mainMod}, R, exec, ${menu-all-command}"
            "${mainMod}, B, exec, ${waybar-theme-command}"
          ];
        };
      };
    };
}
