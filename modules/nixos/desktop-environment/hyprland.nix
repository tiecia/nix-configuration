{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    hyprland.enable = mkEnableOption "Enable Hyprland";
  };

  config = mkIf config.hyprland.enable {
    programs.hyprland.enable = true;
  };
}
