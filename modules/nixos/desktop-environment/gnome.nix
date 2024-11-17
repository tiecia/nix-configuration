{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    gnome.enable = mkEnableOption "Enable GNOME Desktop Environment";
  };

  config = mkIf config.gnome.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    environment.systemPackages = [
      pkgs.gnome.gnome-tweaks
    ];
  };
}
