{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; {
  options = {
    hyprland.enable = mkEnableOption "Enable Hyprland";
  };

  config = mkIf config.hyprland.enable {
    plasma.enable = lib.mkForce false;

    services.xserver = {
      enable = true;
      libinput.enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };

    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };
  };
}
