{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    plasma.enable = mkEnableOption "Enable KDE Plasma Desktop Environment";
  };

  config = mkIf config.plasma.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;

    # Configure keymap in X11
    services.xserver = {
      layout = "us";
      xkbVariant = "";
    };
  };
}
